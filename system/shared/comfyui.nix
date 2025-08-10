{
  imports = [ ./podman.nix ];

  systemd.tmpfiles.rules = [
    "d /home/aaron/AI 0700 aaron aaron"
    "L+ - - - - /home/aaron/AI/comfyui /var/lib/comfyui"
    "Z /var/lib/comfyui 0770 comfyui ai"
    "d /var/lib/comfyui 0770 comfyui ai"
    "d /var/lib/comfyui/custom_nodes 0770 comfyui ai"
    "d /var/lib/comfyui/input 0770 comfyui ai"
    "d /var/lib/comfyui/models 0770 comfyui ai"
    "d /var/lib/comfyui/output 0770 comfyui ai"
    "d /var/lib/comfyui/user 0770 comfyui ai"
    "d /var/lib/comfyui/workflows 0770 comfyui ai"
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
      image = "ghcr.io/siggnal460/comfyui-container-cuda:latest";
      autoStart = true;
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      ports = [ "8188:8188" ];
      volumes = [
        "/var/lib/comfyui/custom_nodes:/app/custom_nodes:rw"
        "/var/lib/comfyui/input:/app/input:rw"
        "/var/lib/comfyui/models:/app/models:rw"
        "/var/lib/comfyui/output:/app/output:rw"
        "/var/lib/comfyui/user:/app/user/default:rw"
      ];
      environment = {
        PUID = "780";
        PGID = "780";
      };
      extraOptions = [
        "--name=comfyui"
        "--gpus=all"
      ];
    };
  };
}
