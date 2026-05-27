{
  pkgs,
  config,
  lib,
  ...
}:
let
  service_account_uid = 1100;
  database_name = "openwebui";
  database_user = "openwebui";
  openwebui_outside_port = 11000;
  openwebui_inside_port = 11000;
  database_port = "5432";
  qdrant_port = "6333";
  valkey_port = "6379";
  gemma4_port = "11434";
  embed_model = "Qwen/Qwen3-Embedding-0.6B";
  embed_port = "11435";
  searxng_port = "8080";
  speaches_port = "8000";
  tika_port = "9998";
in
{
  imports = [
    ../../../shared/podman.nix
  ];

  boot.kernel.sysctl = {
    # For Valkey
    "vm.overcommit_memory" = 1;
  };

  systemd.tmpfiles.rules = [
    "d /etc/searxng 0744 openwebui ai" # needs to be in etc because home.file can't deploy mutable files
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ openwebui_outside_port ];
  };

  users = {
    users.openwebui = {
      isNormalUser = true;
      uid = service_account_uid;
      group = "ai";
      description = "User to run rootless openwebui podman containers";
      linger = true;
      subUidRanges = [
        {
          startUid = 100000;
          count = 65536;
        }
      ];
      subGidRanges = [
        {
          startGid = 100000;
          count = 65536;
        }
      ];
    };
    groups = {
      ai = {
        gid = 780;
      };
    };
  };

  nix.settings.allowed-users = [ "openwebui" ];

  environment.etc = {
    "searxng/settings.yml" = {
      source = lib.mkForce config.sops.templates.searxng-settings.path;
      user = "openwebui";
      group = "ai";
      mode = "0700";
    };
  };

  sops.templates.searxng-settings = {
    owner = "openwebui";
    file = (pkgs.formats.yaml { }).generate "yaml" {
      use_default_settings = true;

      server = {
        port = "${searxng_port}";
        secret_key = "${config.sops.placeholder."openwebui/searxng_secret"}";
        bind_address = "0.0.0.0";
        limiter = false;
        image_proxy = true;
      };

      search = {
        safe_search = 0;
        autocomplete = "google";
        formats = [
          "html"
          "json"
        ];
      };
    };
  };

  # 2. Generate the Limiter TOML file
  environment.etc."searxng/limiter.toml" = {
    mode = "0744"; # Forces a physical copy
    text = ''
      [botdetection.ip_limit]
      link_token = false

      [botdetection.ip_lists]
      block_ip = []
      pass_ip = []
    '';
  };

  systemd.services.create-owui-pod = {
    description = "Rootless Podman Pod for OpenWebUI";
    after = [ "podman.service" ];
    before = [
      "podman-valkey.service"
      "podman-openwebui.service"
      "podman-searxng.service"
      "podman-qdrant.service"
      "podman-vllm-gemma4.service"
      "podman-speaches.service"
    ];
    wantedBy = [
      "multi-user.target"
      "podman-valkey.service"
      "podman-openwebui.service"
      "podman-searxng.service"
      "podman-qdrant.service"
      "podman-vllm-gemma4.service"
      "podman-speaches.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "openwebui";
      Environment = [
        "XDG_RUNTIME_DIR=/run/user/${toString service_account_uid}"
      ];
      ExecStart = [
        "${pkgs.coreutils}/bin/echo 'Checking if pod exists'"
        "/bin/sh -c '${pkgs.podman}/bin/podman pod exists owui || ${pkgs.podman}/bin/podman pod create --name owui -p ${toString openwebui_outside_port}:${toString openwebui_inside_port}'"
        "${pkgs.podman}/bin/podman pod start owui"
        "${pkgs.coreutils}/bin/echo 'Exiting'"
      ];
    };
  };

  virtualisation.oci-containers.containers = {
    valkey = {
      image = "docker.io/valkey/valkey:9";
      podman = {
        user = "openwebui";
        sdnotify = "healthy";
      };
      autoStart = true;
      cmd = [
        "valkey-server"
        "--save"
        "60"
        "1"
        "--loglevel"
        "warning"
      ];
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environmentFiles = [ "/run/secrets/openwebui/valkey" ];
      extraOptions = [
        "--name=valkey"
        "--pod=owui"
        "--health-cmd"
        "valkey-cli -h 127.0.0.1 ping | grep -q PONG || exit 1"
      ];
    };

    postgresql = {
      image = "docker.io/postgres:18";
      podman = {
        user = "openwebui";
        sdnotify = "healthy";
      };
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      volumes = [
        "postgresql:/var/lib/postgresql/18/docker"
      ];
      environmentFiles = [ "/run/secrets/openwebui/postgresql" ];
      environment = {
        POSTGRES_USER = "${database_user}";
        POSTGRES_DB = "${database_name}";
      };
      extraOptions = [
        "--name=postgresql"
        "--pod=owui"
        "--health-cmd"
        "pg_isready -U ${database_user} -d ${database_name}"
      ];
    };

    searxng = {
      image = "docker.io/searxng/searxng:latest";
      podman = {
        user = "openwebui";
        sdnotify = "healthy";
      };
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      volumes = [
        "/etc/searxng:/etc/searxng" # because we cannot deploy in named volume
        "searxng:/var/cache/searxng"
      ];
      environment = {
        SEARXNG_HOSTNAME = "localhost:${searxng_port}/";
        SEARXNG_SETTINGS_TEMPLATE = "search.formats=[html,json]";
      };
      extraOptions = [
        "--name=searxng"
        "--pod=owui"
        "--health-cmd"
        "wget --quiet --tries=1 --spider http://localhost:${searxng_port}/ || exit 1"
        "--cap-drop=all"
        "--cap-add=chown"
        "--cap-add=setgid"
        "--cap-add=setuid"
        "--cap-add=dac_override"
        "--log-driver=json-file"
        "--log-opt=max-size=1m"
        "--log-opt=max-file=1"
      ];
    };

    qdrant = {
      image = "docker.io/qdrant/qdrant:v1-gpu-nvidia";
      podman = {
        user = "openwebui";
        sdnotify = "healthy";
      };
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environmentFiles = [ "/run/secrets/openwebui/qdrant" ];
      environment = {
        QDRANT__GPU__INDEXING = "1";
      };
      extraOptions = [
        "--name=qdrant"
        "--gpus=all"
        "--pod=owui"
        "--health-cmd"
        "bash -c ':> /dev/tcp/127.0.0.1/6333' || exit 1"
      ];
    };

    #ollama = {
    #  image = "docker.io/ollama/ollama:latest";
    #  podman = {
    #    user = "openwebui";
    #    sdnotify = "healthy";
    #  };
    #  volumes = [
    #    "ollama:/root/.ollama"
    #  ];
    #  autoStart = true;
    #  environment = {
    #    OLLAMA_VULKAN = "1";
    #  };
    #  labels = {
    #    "io.containers.autoupdate" = "registry";
    #  };
    #  extraOptions = [
    #    "--name=ollama"
    #    "--gpus=all"
    #    "--pod=owui"
    #    "--health-cmd"
    #    "bash -c '</dev/tcp/localhost/11434' || exit 1"
    #  ];
    #};

    vllm-gemma4 = {
      image = "docker.io/vllm/vllm-openai:latest";
      podman = {
        user = "openwebui";
        sdnotify = "healthy";
      };
      volumes = [
        "vllm-gemma4:/root/.cache/huggingface"
      ];
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      cmd = [
        "--model"
        "nvidia/Gemma-4-26B-A4B-NVFP4"
        "--gpu-memory-utilization"
        "0.75"
        "--max-num-batched-tokens"
        "4096"
        "--dtype"
        "auto"
        "--port"
        "${gemma4_port}"
        "--enable-auto-tool-choice"
        "--tool-call-parser"
        "gemma4"
        "--reasoning-parser"
        "gemma4"
      ];
      extraOptions = [
        "--name=vllm-gemma4"
        "--gpus=0"
        "--pod=owui"
        "--ipc=host"
        "--shm-size=16g"
        "--health-cmd"
        "curl -f http://localhost:${gemma4_port}/health || exit 1"
      ];
    };

    vllm-embed = {
      image = "docker.io/vllm/vllm-openai:latest";
      podman = {
        user = "openwebui";
        sdnotify = "healthy";
      };
      volumes = [
        "vllm-embed:/root/.cache/huggingface"
      ];
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      cmd = [
        "--model"
        "${embed_model}"
        "--gpu-memory-utilization"
        "0.5"
        "--port"
        "${embed_port}"
        "--runner"
        "pooling"
      ];
      extraOptions = [
        "--name=vllm-embed"
        "--gpus=1"
        "--pod=owui"
        "--ipc=host"
        "--shm-size=16g"
        "--health-cmd"
        "curl -f http://localhost:${embed_port}/health || exit 1"
      ];
    };

    speaches = {
      image = "ghcr.io/speaches-ai/speaches:latest-cuda";
      podman = {
        user = "openwebui";
        sdnotify = "healthy";
      };
      autoStart = true;
      environment = {
        SPEACHES_BASE_URL = "http://localhost:${speaches_port}";
      };
      volumes = [
        "speaches:/home/ubuntu/.cache/huggingface/hub"
      ];
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      extraOptions = [
        "--name=speaches"
        "--gpus=all"
        "--pod=owui"
        "--health-cmd"
        "curl -f http://127.0.0.1:8000/health || exit 1"
      ];
    };

    tika = {
      image = "docker.io/apache/tika:latest-full";
      podman = {
        user = "openwebui";
        sdnotify = "healthy";
      };
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      extraOptions = [
        "--name=tika"
        "--pod=owui"
        "--health-cmd"
        "wget --quiet --tries=1 --spider http://localhost:${tika_port}"
      ];
    };

    openwebui = {
      image = "ghcr.io/open-webui/open-webui:latest";
      podman = {
        user = "openwebui";
        sdnotify = "healthy";
      };
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      volumes = [
        "openwebui:/app/backend/data"
      ];
      environmentFiles = [ "/run/secrets/openwebui/openwebui" ];
      environment = {
        PORT = "${toString openwebui_inside_port}";
        WEBUI_URL = "https://owui.gappyland.org";
        CORS_ALLOW_ORIGIN = "https://owui.gappyland.org";
        WEBUI_ADMIN_EMAIL = "siggnal@proton.me";
        ENABLE_SIGNUP = "false";
        ENABLE_OAUTH_SIGNUP = "true";
        OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "true";
        OPENID_PROVIDER_URL = "https://auth.gappyland.org/.well-known/openid-configuration";
        OAUTH_PROVIDER_NAME = "Authelia";
        OAUTH_SCOPES = "openid email profile groups";
        USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36";
        ENABLE_OAUTH_ROLE_MANAGEMENT = "true";
        OAUTH_ALLOWED_ROLES = "openwebui,openwebui-admin";
        OAUTH_ADMIN_ROLES = "openwebui-admin";
        OAUTH_ROLES_CLAIM = "groups";
        OAUTH_CODE_CHALLENGE_METHOD = "S256";
        ENABLE_LOGIN_FORM = "false";
        ENABLE_PASSWORD_AUTH = "false";
        USE_CUDA_DOCKER = "true";
        DOCKER = "true";
        #OLLAMA_BASE_URL = "http://localhost:${ollama_port}";
        ENABLE_OPENAI_API = "true";
        OPENAI_API_BASE_URL = "http://localhost:${gemma4_port}";
        VECTOR_DB = "qdrant";
        QDRANT_URI = "http://localhost:${qdrant_port}";
        DATABASE_TYPE = "postgresql";
        DATABASE_NAME = "${database_name}";
        DATABASE_USER = "${database_user}";
        DATABASE_HOST = "localhost";
        DATABASE_PORT = "${database_port}";
        REDIS_URL = "redis://localhost:${valkey_port}/0";
        WEBSOCKET_MANAGER = "redis";
        ENABLE_WEB_SEARCH = "true";
        WEB_SEARCH_ENGINE = "searxng";
        WEB_SEARCH_RESULT_COUNT = "3";
        WEB_SEARCH_CONCURRENT_REQUESTS = "10";
        SEARXNG_QUERY_URL = "http://localhost:${searxng_port}/search?q=<query>";
        AUDIO_TTS_API_KEY = "not-needed";
        AUDIO_TTS_ENGINE = "openai";
        AUDIO_TTS_OPENAI_API_BASE_URL = "http://localhost:${speaches_port}/v1";
        AUDIO_TTS_OPENAI_API_KEY = "not-needed";
        AUDIO_STT_ENGINE = "openai";
        AUDIO_STT_OPENAI_API_BASE_URL = "http://localhost:${speaches_port}/v1";
        AUDIO_STT_OPENAI_API_KEY = "not-needed";
        CONTENT_EXTRACTION_ENGINE = "tika";
        TIKA_SERVER_URL = "http://localhost:${tika_port}";
        CHUNK_SIZE = "2000";
        CHUNK_OVERLAP = "200";
        RAG_TOP_K = "15";
        RAG_TEXT_SPLITTER = "token";
        RAG_EMBEDDING_ENGINE = "openai";
        RAG_EMBEDDING_MODEL = "${embed_model}";
        RAG_OPENAI_API_BASE_URL = "http://localhost:${embed_port}/v1";
      };
      dependsOn = [
        "valkey"
        "postgresql"
        "qdrant"
        "vllm-embed"
        "vllm-gemma4"
        "searxng"
        "speaches"
        "tika"
      ];
      extraOptions = [
        "--name=openwebui"
        "--gpus=all"
        "--pod=owui"
        "--health-cmd"
        "curl -f http://localhost:${toString openwebui_inside_port} || exit 1"
      ];
    };
  };

  sops.secrets = {
    "openwebui/openwebui".owner = "openwebui";
    "openwebui/valkey".owner = "openwebui";
    "openwebui/postgresql".owner = "openwebui";
    "openwebui/qdrant".owner = "openwebui";
    "openwebui/searxng_secret".owner = "openwebui";
  };
}
