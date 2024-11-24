# Remote AI content generation
{
  imports = [
    ../../../shared/latest-kernel.nix
    ./systemd/model-loader.nix
    ./systemd/custom-node-loader.nix
  ];

  systemd.tmpfiles.rules = [
    "d /oci_cache 0775 root users"
    "d /oci_cache/comfyui 0775 root users"
    "d /oci_cache/comfyui/pip 0770 root users"

    "d /export/ai 0775 root users"

    "d /export/ai/appdata 0775 root users"
    "d /export/ai/appdata/ollama 0770 root users"
    "d /export/ai/appdata/open-webui/data 0770 root users"
    "d /export/ai/appdata/sillytavern/data 0770 root users"
    "d /export/ai/appdata/sillytavern/config 0770 root users"
    "d /export/ai/appdata/sillytavern/plugins 0770 root users"
    "d /export/ai/appdata/openedai-speech/voices 0770 root users"
    "d /export/ai/appdata/openedai-speech/config 0770 root users"
    "d /export/ai/appdata/comfyui/custom_nodes 0775 root users"
    "d /export/ai/appdata/comfyui/workflows 0770 root users"

    "d /export/ai/models/checkpoints 0775 root users"
    "d /export/ai/models/controlnet 0775 root users"
    "d /export/ai/models/clip 0775 root users"
    "d /export/ai/models/clip_vision 0775 root users"
    "d /export/ai/models/clip_vision/SD1.5 0775 root users"
    "d /export/ai/models/diffusion_models 0775 root users"
    "d /export/ai/models/embeddings 0775 root users"
    "d /export/ai/models/inpaint 0775 root users"
    "d /export/ai/models/ipadapter 0775 root users"
    "d /export/ai/models/loras 0775 root users"
    "d /export/ai/models/onnx 0775 root users"
    "d /export/ai/models/sams 0775 root users"
    "d /export/ai/models/ultralytics 0775 root users"
    "d /export/ai/models/unet 0775 root users"
    "d /export/ai/models/upscale_models 0775 root users"
    "d /export/ai/models/vae 0775 root users"

    "d /export/ai/images 0775 root users"
  ];

  services.nfs.server = {
    exports = ''/export/ai 10.0.0.10(rw,nohide,insecure,no_subtree_check)'';
  };

  virtualisation.oci-containers.containers = {
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
        "/export/ai/appdata/openedai-speech/voices:/app/voices"
        "/export/ai/appdata/openedai-speech/config:/app/config"
      ];
      extraOptions = [
        "--name=openedai-speech"
        "--gpus=1"
      ];
    };

    ollama = {
      image = "docker.io/ollama/ollama";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [ "11434:11434" ];
      volumes = [
        "/export/ai/appdata/ollama:/root/.ollama"
      ];
      extraOptions = [
        "--name=ollama"
        "--gpus=all"
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
        "--gpus=all"
      ];
      volumes = [
        "/export/ai/appdata/sillytavern/data:/home/node/app/data"
        "/export/ai/appdata/sillytavern/config:/home/node/app/config"
        "/export/ai/appdata/sillytavern/plugins:/home/node/app/plugins"
      ];
    };

    open-webui = {
      image = "ghcr.io/open-webui/open-webui:main";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [ "3000:8080" ];
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
        AUDIO_TTS_MODEL = "tts-1-hd";
        AUDIO_TTS_ENGINE = "openai";
        AUDIO_TTS_OPENAI_API_KEY = "sk-111111111";
        AUDIO_TTS_OPENAI_API_BASE_URL = "http://host.docker.internal:8000/v1";
        USER_AGENT = "myagent";
      };
      extraOptions = [
        "--name=open-webui"
        "--gpus=all"
      ];
      volumes = [
        "/export/ai/appdata/open-webui/data:/app/backend/data"
      ];
    };

    comfyui = {
      image = "docker.io/obeliks/comfyui:latest-cu121";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [ "8188:8188" ];
      environment = {
        HF_HOME = "/cache/huggingface/hub";
        COMFYUI_PATH = "/app";
        COMFYUI_MODEL_PATH = "/app/models";
        COMFYUI_EXTRA_ARGS = "--lowvram --multi-user";
      };
      volumes = [
        "/oci_cache/comfyui:/cache/huggingface/hub/hub"
        "/oci_cache/comfyui/pip:/cache/pip"
        "/export/ai/images:/app/output"
        "/export/ai/appdata/comfyui/custom_nodes:/app/custom_nodes"
        "/export/ai/models/checkpoints:/app/models/checkpoints"
        "/export/ai/models/controlnet:/app/models/controlent"
        "/export/ai/models/clip:/app/models/clip"
        "/export/ai/models/clip_vision:/app/models/clip_vision"
        "/export/ai/models/diffusion_models:/app/models/diffusion_models"
        "/export/ai/models/embeddings:/app/models/embeddings"
        "/export/ai/models/inpaint:/app/models/inpaint"
        "/export/ai/models/ipadapter:/app/models/ipadapter"
        "/export/ai/models/loras:/app/models/loras"
        "/export/ai/models/onnx:/app/models/onnx"
        "/export/ai/models/sams:/app/models/sams"
        "/export/ai/models/ultralytics:/app/models/ultralytics"
        "/export/ai/models/unet:/app/models/unet"
        "/export/ai/models/upscale_models:/app/models/upscale_models"
        "/export/ai/models/vae:/app/models/vae"
      ];
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
    };
  };
}
