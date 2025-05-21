{
  imports = [
    ./podman.nix
  ];

  systemd.tmpfiles.rules = [
    "d /var/lib/comfyui 0770 comfyui ai"
    "d /var/lib/comfyui/custom_nodes 0770 comfyui ai"
		"d /var/lib/comfyui/input 0770 comfyui ai"
		"d /var/lib/comfyui/output 0770 comfyui ai"
		"d /var/lib/comfyui/workflows 0770 comfyui ai"
		"d /var/lib/comfyui/models 0770 comfyui ai"
		"d /var/lib/comfyui/models/checkpoints 0770 comfyui ai"
		"d /var/lib/comfyui/models/clip 0770 comfyui ai"
		"d /var/lib/comfyui/models/clip_vision 0770 comfyui ai"
		"d /var/lib/comfyui/models/configs 0770 comfyui ai"
		"d /var/lib/comfyui/models/controlnet 0770 comfyui ai"
		"d /var/lib/comfyui/models/diffusers 0770 comfyui ai"
		"d /var/lib/comfyui/models/diffusion_models 0770 comfyui ai"
		"d /var/lib/comfyui/models/embeddings 0770 comfyui ai"
		"d /var/lib/comfyui/models/fooocus_expansion 0770 comfyui ai"
		"d /var/lib/comfyui/models/gligen 0770 comfyui ai"
		"d /var/lib/comfyui/models/hypernetworks 0770 comfyui ai"
		"d /var/lib/comfyui/models/inpaint 0770 comfyui ai"
		"d /var/lib/comfyui/models/ipadapter 0770 comfyui ai"
		"d /var/lib/comfyui/models/loras 0770 comfyui ai"
		"d /var/lib/comfyui/models/photomaker 0770 comfyui ai"
		"d /var/lib/comfyui/models/prompt_expansion 0770 comfyui ai"
		"d /var/lib/comfyui/models/safety_checker 0770 comfyui ai"
		"d /var/lib/comfyui/models/sam 0770 comfyui ai"
		"d /var/lib/comfyui/models/style_models 0770 comfyui ai"
		"d /var/lib/comfyui/models/text_encoders 0770 comfyui ai"
		"d /var/lib/comfyui/models/unet 0770 comfyui ai"
		"d /var/lib/comfyui/models/upscale_models 0770 comfyui ai"
		"d /var/lib/comfyui/models/vae 0770 comfyui ai"
		"d /var/lib/comfyui/models/vae_approx 0770 comfyui ai"
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

  virtualisation.oci-containers.containers = {
		comfyui = {
      image = "ghcr.io/lecode-official/comfyui-docker:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [ "8188:8188" ];
      volumes = [
        "/var/lib/comfyui/models:/opt/comfyui/models:rw"
        "/var/lib/comfyui/output:/opt/comfyui/output:rw"
        "/var/lib/comfyui/input:/opt/comfyui/input:rw"
        "/var/lib/comfyui/workflows:/opt/comfyui/user/default/workflows:rw"
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
	};
}
