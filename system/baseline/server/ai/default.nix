{
  pkgs,
  ...
}:
let
  service_account_uid = 1100;
  openwebui_outside_port = 11000;
  openwebui_inside_port = 11000;
  valkey_port = "6379";
  gemma4_port = "11434";
  comfyui_port = "8188";
in
{
  imports = [
    ../../../shared/podman.nix
  ];

  services.userborn.enable = false;

  boot.kernel.sysctl = {
    # For Valkey
    "vm.overcommit_memory" = 1;
  };

  systemd.tmpfiles.rules = [
    "d /var/ai 0774 root ai"

    "d /var/ai/toolkit 0770 root wheel"
    "d /var/ai/toolkit/datasets 0770 root wheel"
    "d /var/ai/toolkit/config 0770 root wheel"
    "d /var/ai/toolkit/output 0770 root wheel"

    "d /var/ai/comfyui 0770 openwebui ai"
    "Z /var/ai/comfyui 0770 openwebui ai"
    "d /var/ai/comfyui/custom_nodes 0770 openwebui ai"
    "d /var/ai/comfyui/models 0770 openwebui ai"
    "d /var/ai/comfyui/user 0770 openwebui ai"
  ];

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      openwebui_outside_port
      8188
    ];
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

  systemd.services.create-owui-pod = {
    description = "Rootless Podman Pod for OpenWebUI";
    after = [ "user@${toString service_account_uid}.service" ];
    requires = [ "user@${toString service_account_uid}.service" ];
    before = [
      "podman-valkey.service"
      "podman-openwebui.service"
      "podman-vllm-gemma4.service"
      "podman-comfyui.service"
    ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      User = "openwebui";
      Environment = [
        "XDG_RUNTIME_DIR=/run/user/${toString service_account_uid}"
        "PATH=/run/wrappers/bin:/run/current-system/sw/bin"
      ];
      ExecStartPre = [
        "-${pkgs.podman}/bin/podman pod stop owui"
        "-${pkgs.podman}/bin/podman pod rm owui"
      ];
      ExecStart = [
        "${pkgs.podman}/bin/podman pod create --name owui -p ${toString openwebui_outside_port}:${toString openwebui_inside_port} -p 8188:${comfyui_port}"
      ];
    };
  };

  virtualisation.oci-containers.containers = {
    comfyui = {
      image = "ghcr.io/siggnal460/comfyui-container-cuda:latest";
      podman = {
        user = "openwebui";
        sdnotify = "healthy";
      };
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      volumes = [
        "/var/ai/comfyui/custom_nodes:/app/custom_nodes:rw"
        "/var/ai/comfyui/models:/app/models:rw"
        "/var/ai/comfyui/user:/app/user:rw"
      ];
      environment = {
        PUID = "780";
        PGID = "780";
        COMFYUI_ARGS = "--max-upload-size 999999999";
      };
      dependsOn = [ "openwebui" ];
      extraOptions = [
        "--name=comfyui"
        "--pod=owui"
        "--gpus=all"
        "--health-cmd"
        "bash -c ':> /dev/tcp/127.0.0.1/${comfyui_port}' || exit 1"
      ];
    };

    # ai-toolkit = {
    #   image = "docker.io/ostris/aitoolkit:latest";
    #   autoStart = true;
    #   ports = [
    #     "8675:8675"
    #   ];
    #   labels = {
    #     "io.containers.autoupdate" = "registry";
    #   };
    #   volumes = [
    #     "/root/.cache/huggingface/hub:/root/.cache/huggingface/hub"
    #     "/var/ai/toolkit/datasets:/app/ai-toolkit/datasets"
    #     "/var/ai/toolkit/output:/app/ai-toolkit/output"
    #     "/var/ai/toolkit/config:/app/ai-toolkit/config"
    #     "/var/ai/comfyui/models:/app/ai-toolkit/models"
    #     "/dev/shm:/dev/shm"
    #   ];
    #   extraOptions = [
    #     "--name=ai-toolkit"
    #     "--gpus=all"
    #     "--shm-size=2g"
    #   ];
    # };

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
      extraOptions = [
        "--name=valkey"
        "--pod=owui"
        "--health-cmd"
        "valkey-cli -h 127.0.0.1 ping | grep -q PONG || exit 1"
      ];
    };

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
        # "huihui-ai/Huihui-gemma-4-E2B-it-abliterated"
        "AEON-7/Gemma-4-12B-it-AEON-Abliterated-K4-NVFP4"
        "--gpu-memory-utilization"
        "0.95"
        "--port"
        "${gemma4_port}"
        "--enable-auto-tool-choice"
        "--tool-call-parser"
        "gemma4"
        "--max-model-len"
        "5800"
      ];
      extraOptions = [
        "--name=vllm-gemma4"
        "--gpus=1"
        "--pod=owui"
        "--ipc=host"
        "--shm-size=16g"
        "--health-cmd"
        "curl -f http://localhost:${gemma4_port}/health || exit 1"
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
      environment = {
        PORT = "${toString openwebui_inside_port}";
        ENABLE_SIGNUP = "false";
        USER_AGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36";
        ENABLE_LOGIN_FORM = "true";
        ENABLE_PASSWORD_AUTH = "true";
        USE_CUDA_DOCKER = "true";
        DOCKER = "true";
        ENABLE_OPENAI_API = "true";
        OPENAI_API_BASE_URL = "http://localhost:${gemma4_port}/v1";
        REDIS_URL = "redis://localhost:${valkey_port}/0";
        WEBSOCKET_MANAGER = "redis";
        WEBUI_AUTH = "true";
        ENABLE_PERSISTENT_CONFIG = "false";
        ENABLE_API_KEYS = "true";
        ENABLE_OLLAMA_API = "false";
      };
      dependsOn = [
        "valkey"
        "vllm-gemma4"
      ];
      extraOptions = [
        "--name=openwebui"
        "--gpus=1"
        "--pod=owui"
        "--health-cmd"
        "curl -f http://localhost:${toString openwebui_inside_port} || exit 1"
      ];
    };
  };
}
