{ pkgs, lib, ... }:
let
  downloadFiles =
    files:
    let
      downloadInputEntry = lib.concatStringsSep "\n" (
        map (file: "${file.url}\n  dir=${file.output_dir}\n  out=${file.filename}") files
      );
    in
    ''
      echo "${downloadInputEntry}" > /tmp/model-downloads.txt
      ${pkgs.aria2}/bin/aria2c \
      	--continue \
      	--max-overall-download-limit=10M \
      	--no-conf \
      	--input-file=/tmp/model-downloads.txt
    '';
  model_files = [
    {
      filename = "flux1-dev-fp8.safetensors";
      output_dir = "/export/ai/models/checkpoints";
      url = "https://huggingface.co/Comfy-Org/flux1-dev/resolve/main/flux1-dev-fp8.safetensors";
    }
    {
      filename = "sd3.5_large.safetensors";
      output_dir = "/export/ai/models/checkpoints";
      url = "https://huggingface.co/Comfy-Org/stable-diffusion-3.5-fp8/resolve/main/sd3.5_large_fp8_scaled.safetensors";
    }
    {
      filename = "flux1-dev-fp8-e4m3fn.safetensors";
      output_dir = "/export/ai/models/unet";
      url = "https://huggingface.co/Kijai/flux-fp8/resolve/main/flux1-dev-fp8-e4m3fn.safetensors";
    }
    {
      filename = "flux1-schnell.safetensors";
      output_dir = "/export/ai/models/unet";
      url = "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/flux1-schnell.safetensors";
    }
    {
      filename = "clip_l.safetensors";
      output_dir = "/export/ai/models/clip/flux";
      url = "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors";
    }
    {
      filename = "clip_g.safetensors";
      output_dir = "/export/ai/models/clip/sd";
      url = "https://huggingface.co/Comfy-Org/stable-diffusion-3.5-fp8/resolve/main/text_encoders/clip_g.safetensors";
    }
    {
      filename = "google_t5xxl_fp8_e4m3fn.safetensors";
      output_dir = "/export/ai/models/clip";
      url = "https://huggingface.co/mcmonkey/google_t5-v1_1-xxl_encoderonly/resolve/main/t5xxl_fp8_e4m3fn.safetensors";
    }
    {
      filename = " t5xxl_fp16_e4m3fn.safetensors";
      output_dir = "/export/ai/models/clip/flux";
      url = "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp16.safetensors";
    }
    {
      filename = " t5xxl_fp8_e4m3fn.safetensors";
      output_dir = "/export/ai/models/clip/sd";
      url = "https://huggingface.co/Comfy-Org/stable-diffusion-3.5-fp8/resolve/main/text_encoders/t5xxl_fp8_e4m3fn.safetensors";
    }
    {
      filename = " t5xxl_fp8_e4m3fn.safetensors";
      output_dir = "/export/ai/models/clip/flux";
      url = "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn.safetensors";
    }
    {
      filename = "ae.safetensors";
      output_dir = "/export/ai/models/vae";
      url = "https://huggingface.co/black-forest-labs/FLUX.1-schnell/resolve/main/ae.safetensors";
    }
    {
      filename = "8-step-flux.safetensors";
      output_dir = "/export/ai/models/loras";
      url = "https://huggingface.co/alimama-creative/FLUX.1-Turbo-Alpha/resolve/main/diffusion_pytorch_model.safetensors";
    }
    {
      filename = "SD1.5/model.safetensors";
      output_dir = "/export/ai/models/clip_vision";
      url = "https://huggingface.co/h94/IP-Adapter/resolve/main/models/image_encoder/model.safetensors";
    }
    {
      filename = "NMKD Superscale SP_178000_G.pth";
      output_dir = "/export/ai/models/upscale_models";
      url = "https://huggingface.co/gemasai/4x_NMKD-Superscale-SP_178000_G/resolve/main/4x_NMKD-Superscale-SP_178000_G.pth";
    }
    {
      filename = "OmniSR_X2_DIV2K.safetensors";
      output_dir = "/export/ai/models/upscale_models";
      url = "https://huggingface.co/Acly/Omni-SR/resolve/main/OmniSR_X2_DIV2K.safetensors";
    }
    {
      filename = "OmniSR_X3_DIV2K.safetensors";
      output_dir = "/export/ai/models/upscale_models";
      url = "https://huggingface.co/Acly/Omni-SR/resolve/main/OmniSR_X3_DIV2K.safetensors";
    }
    {
      filename = "OmniSR_X4_DIV2K.safetensors";
      output_dir = "/export/ai/models/upscale_models";
      url = "https://huggingface.co/Acly/Omni-SR/resolve/main/OmniSR_X4_DIV2K.safetensors";
    }
    {
      filename = "MAT_Places512_G_fp16.safetensors";
      output_dir = "/export/ai/models/inpaint";
      url = "https://huggingface.co/Acly/MAT/resolve/main/MAT_Places512_G_fp16.safetensors";
    }
    {
      filename = "diffusion_pytorch_model.safetensors";
      output_dir = "/export/ai/models/controlnet/flux";
      url = "https://huggingface.co/InstantX/FLUX.1-dev-Controlnet-Union/resolve/main/diffusion_pytorch_model.safetensors";
    }
    {
      filename = "pulid_flux_v0.9.1.safetensors";
      output_dir = "/export/ai/models/pulid";
      url = "https://huggingface.co/guozinan/PuLID/resolve/main/pulid_flux_v0.9.1.safetensors";
    }
  ];
in
{
  systemd.services.model-loader = {
    description = "AI model background downloads";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-tmpfiles-setup.service" ];
    serviceConfig = {
      Type = "exec";
      Restart = "on-failure";
      RestartSec = "10min";
      RestartMaxDelaySec = "10h";
      RestartSteps = "10";
    };

    script = "${downloadFiles model_files}";
  };
}
