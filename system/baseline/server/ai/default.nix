# Remote AI content generation
{ pkgs, ... }:
{
  imports = [
    ../../../shared/podman.nix
  ];

  systemd.tmpfiles.rules = [
    "d /var/lib/invokeai 0774 root users"
    "d /var/lib/comfyui 0774 comfyui ai"
    "d /var/lib/comfyui/custom_nodes 0774 comfyui ai"
    "d /var/lib/comfyui/input 0774 comfyui ai"
    "d /var/lib/ollama 0774 root users"
    "d /var/lib/open-webui/data 0770 root users"
    "d /var/lib/openedai-speech/voices 0770 root users"
    "d /var/lib/openedai-speech/config 0770 root users"
    "d /var/lib/sillytavern/data 0770 root users"
    "d /var/lib/sillytavern/config 0770 root users"
    "d /var/lib/sillytavern/plugins 0770 root users"

    "d /export/ai/models/checkpoints 0774 root ai"
    "d /export/ai/models/clip 0774 root ai"
    "d /export/ai/models/clip_vision 0774 root ai"
    "d /export/ai/models/configs 0774 root ai"
    "d /export/ai/models/controlnet 0774 root ai"
    "d /export/ai/models/diffusers 0774 root ai"
    "d /export/ai/models/diffusion_models 0774 root ai"
    "d /export/ai/models/embeddings 0774 root ai"
    "d /export/ai/models/fooocus_expansion 0774 root ai"
    "d /export/ai/models/gligen 0774 root ai"
    "d /export/ai/models/hypernetworks 0774 root ai"
    "d /export/ai/models/inpaint 0774 root ai"
    "d /export/ai/models/ipadapter 0774 root ai"
    "d /export/ai/models/loras 0774 root ai"
    "d /export/ai/models/photomaker 0774 root ai"
    "d /export/ai/models/prompt_expansion 0774 root ai"
    "d /export/ai/models/safety_checker 0774 root ai"
    "d /export/ai/models/sam 0774 root ai"
    "d /export/ai/models/style_models 0774 root ai"
    "d /export/ai/models/text_encoders 0774 root ai"
    "d /export/ai/models/unet 0774 root ai"
    "d /export/ai/models/upscale_models 0774 root ai"
    "d /export/ai/models/vae 0774 root ai"
    "d /export/ai/models/vae_approx 0774 root ai"

    "d /export/ai 0774 root ai"
    "d /export/ai/models 0774 root ai"
    "d /export/ai/output 0774 comfyui ai"
    "d /export/ai/input 0774 comfyui ai"
    "d /export/ai/workflows 0774 comfyui ai"
  ];

  users = {
    users.comfyui = {
      uid = 780;
      isSystemUser = true;
      group = "ai";
    };
    groups = {
      ai = {
        gid = 780;
      };
    };
  };

  services.nfs.server = {
    exports = ''/export/ai x86-atxtwr-workstation(rw,nohide,insecure,no_subtree_check)'';
  };

  virtualisation.oci-containers.containers = {
    invokeai = {
      image = "ghcr.io/invoke-ai/invokeai:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      environmentFiles = [ "/run/secrets/invokeai_secrets" ];
      environment = {
        NVIDIA_DRIVER_CAPABILITIES = "all";
        NVIDIA_VISIBLE_DEVICES = "all";
      };
      volumes = [ "/var/lib/invokeai:/invokeai" ];
      ports = [ "9091:9090" ];
      extraOptions = [
        "--name=invokeai"
        "--gpus=all"
        "--group-add=users"
      ];
    };

    openedai-speech = {
      image = "ghcr.io/matatonic/openedai-speech";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [ "8000:8000" ];
      environment = {
        TTS_HOME = "voices";
        HF_HOME = "voices";
      };
      volumes = [
        "/var/lib/openedai-speech/voices:/app/voices"
        "/var/lib/openedai-speech/config:/app/config"
      ];
      extraOptions = [
        "--name=openedai-speech"
        "--gpus=all"
      ];
    };

    kokoro = {
      image = "ghcr.io/remsky/kokoro-fastapi-gpu:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [ "8880:8880" ];
      extraOptions = [
        "--name=kokoro"
        "--gpus=all"
      ];
    };

    ollama = {
      image = "docker.io/ollama/ollama";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [ "11434:11434" ];
      volumes = [ "/var/lib/ollama:/root/.ollama" ];
      extraOptions = [
        "--name=ollama"
        "--gpus=all"
        "--group-add=users"
      ];
    };

    sillytavern = {
      image = "ghcr.io/sillytavern/sillytavern:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [ "4000:8000" ];
      extraOptions = [
        "--name=sillytavern"
        "--group-add=users"
      ];
      volumes = [
        "/var/lib/sillytavern/data:/home/node/app/data"
        "/var/lib/sillytavern/config:/home/node/app/config"
        "/var/lib/sillytavern/plugins:/home/node/app/plugins"
      ];
    };

    open-webui = {
      image = "ghcr.io/open-webui/open-webui:main";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [ "3000:8080" ];
      environmentFiles = [ "/run/secrets/openwebui_secrets" ];
      environment = {
        WEBUI_AUTH = "True";
        ANONYMIZED_TELEMETRY = "False";
        DO_NOT_TRACK = "True";
        SCARF_NO_ANALYTICS = "True";
        OLLAMA_BASE_URL = "http://host.docker.internal:11434";
        RAG_WEB_SEARCH_ENGINE = "duckduckgo";
        ENABLE_IMAGE_GENERATION = "True";
        IMAGE_GENERATION_ENGINE = "comfyui";
        COMFYUI_BASE_URL = "http://host.docker.internal:8188";
        ENABLE_OPENAI_API = "False";
        AUDIO_TTS_MODEL = "kokoro";
        AUDIO_TTS_ENGINE = "openai";
        AUDIO_TTS_VOICE = "bf_emma";
        AUDIO_TTS_OPENAI_API_KEY = "sk-111111111";
        AUDIO_TTS_OPENAI_API_BASE_URL = "http://host.docker.internal:8880/v1";
        USER_AGENT = "myagent";
        USER_CUDE_DOCKER = "true";
        # Authelia config
        ENABLE_OAUTH_SIGNUP = "true";
        OAUTH_MERGE_ACCOUNTS_BY_EMAIL = "true";
        OPENID_PROVIDER_URL = "https://auth.gappyland.org/.well-known/openid-configuration";
        OAUTH_PROVIDER_NAME = "Authelia";
        OAUTH_SCOPES = "openid email profile groups";
        ENABLE_OAUTH_ROLE_MANAGEMENT = "true";
        OAUTH_ALLOWED_ROLES = "openwebui,openwebui-admin";
        OAUTH_ADMIN_ROLES = "openwebui-admin";
        OAUTH_ROLES_CLAIM = "groups";
      };
      extraOptions = [
        "--name=open-webui"
        "--group-add=users"
      ];
      volumes = [ "/var/lib/open-webui/data:/app/backend/data" ];
    };

    ## Doesn't work rn
    comfyui = {
      image = "ghcr.io/lecode-official/comfyui-docker:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [ "8188:8188" ];
      volumes = [
        "/export/ai/models:/opt/comfyui/models:rw"
        "/export/ai/output:/opt/comfyui/output:rw"
        "/export/ai/input:/opt/comfyui/input:rw"
        "/export/ai/workflows:/opt/comfyui/user/default/workflows:rw"
        "/var/lib/comfyui/custom_nodes:/opt/comfyui/custom_nodes:rw"
      ];
      environment = {
        USER_ID = "780";
        GROUP_ID = "780";
        NVIDIA_DRIVER_CAPABILITIES = "all";
        NVIDIA_VISIBLE_DEVICES = "all";
      };
      extraOptions = [
        "--name=comfyui"
        "--gpus=all"
      ];
    };

    fluxgym = {
      image = "docker.io/thelocallab/fluxgym-flux-lora-training";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [ "7860:7860" ];
      extraOptions = [
        "--name=fluxgym"
        "--gpus=all"
        "--group-add=users"
      ];
    };
  };

  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  sops.secrets = {
    "invokeai_secrets".owner = "root";
    "openwebui_secrets".owner = "root";
  };
}
