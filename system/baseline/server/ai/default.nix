# Remote AI content generation
{
  imports = [
    ../../../shared/latest-kernel.nix
    ../../../shared/podman.nix
    ./systemd/model-loader.nix
    ./systemd/custom-node-loader.nix
  ];

  systemd.tmpfiles.rules = [
    "d /oci_cache 0774 root root"
    "d /oci_cache/comfyui 0774 root users"
    "d /oci_cache/comfyui/huggingface 0770 root users"
    "d /oci_cache/comfyui/pip 0770 root users"
    "d /oci_cache/comfyui/matplotlib 0770 root users"

    "d /venv/comfyui/lib 0770 root users"
    "d /venv/comfyui/lib64 0770 root users"

    "d /export/ai 0774 root users"

    "d /export/ai/appdata 0774 root users"
    "d /export/ai/appdata/ollama 0770 root users"
    "d /export/ai/appdata/open-webui/data 0770 root users"
    "d /export/ai/appdata/sillytavern/data 0770 root users"
    "d /export/ai/appdata/sillytavern/config 0770 root users"
    "d /export/ai/appdata/sillytavern/plugins 0770 root users"
    "d /export/ai/appdata/openedai-speech/voices 0770 root users"
    "d /export/ai/appdata/openedai-speech/config 0770 root users"
    "d /export/ai/appdata/comfyui/custom_nodes 0770 root users"
    "d /export/ai/appdata/comfyui/workflows 0770 root users"

    "d /export/ai/models 0774 root users"
    "d /export/ai/models/checkpoints 0770 root users"
    "d /export/ai/models/controlnet 0770 root users"
    "d /export/ai/models/clip 0770 root users"
    "d /export/ai/models/clip_vision 0770 root users"
    "d /export/ai/models/clip_vision/SD1.5 0770 root users"
    "d /export/ai/models/diffusion_models 0770 root users"
    "d /export/ai/models/embeddings 0770 root users"
    "d /export/ai/models/inpaint 0770 root users"
    "d /export/ai/models/ipadapter 0770 root users"
    "d /export/ai/models/liveportrait 0770 root users"
    "d /export/ai/models/loras 0770 root users"
    "d /export/ai/models/pulid 0770 root users"
    "d /export/ai/models/onnx 0770 root users"
    "d /export/ai/models/sams 0770 root users"
    "d /export/ai/models/ultralytics 0770 root users"
    "d /export/ai/models/unet 0770 root users"
    "d /export/ai/models/upscale_models 0770 root users"
    "d /export/ai/models/vae 0770 root users"

    "d /export/ai/images 0770 root users"
  ];

  services.nfs.server = {
    exports = ''/export/ai 10.0.0.15(rw,nohide,insecure,no_subtree_check)'';
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
        "--gpus=all"
        "--group-add=users"
      ];
    };

    ollama = {
      image = "docker.io/ollama/ollama";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [ "11434:11434" ];
      volumes = [ "/export/ai/appdata/ollama:/root/.ollama" ];
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
        "--group-add=users"
      ];
      volumes = [ "/export/ai/appdata/open-webui/data:/app/backend/data" ];
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
        #COMFYUI_EXTRA_ARGS = "--lowvram";
      };
      volumes = [
        "/oci_cache/comfyui:/cache"
        #"/venv/comfyui/lib:/app/venv/lib"
        #"/venv/comfyui/lib64:/app/venv/lib64"
        "/export/ai/images:/app/output"
        "/export/ai/appdata/comfyui/custom_nodes:/app/custom_nodes"
        "/export/ai/models/checkpoints:/app/models/checkpoints"
        "/export/ai/models/controlnet:/app/models/controlnet"
        "/export/ai/models/clip:/app/models/clip"
        "/export/ai/models/clip_vision:/app/models/clip_vision"
        "/export/ai/models/diffusion_models:/app/models/diffusion_models"
        "/export/ai/models/embeddings:/app/models/embeddings"
        "/export/ai/models/inpaint:/app/models/inpaint"
        "/export/ai/models/ipadapter:/app/models/ipadapter"
        "/export/ai/models/liveportrait:/app/models/liveportrait"
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
        "--group-add=users"
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
}
