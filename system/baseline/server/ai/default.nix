{ ... }:
{
  imports = [
    ../../../shared/podman.nix
  ];

  systemd.tmpfiles.rules = [
    "d /export/ai 0774 root ai"

    "d /var/ai 0770 root ai"
    "d /var/ai/comfyui 0770 comfyui wheel"
    "d /var/ai/comfyui/models 0770 comfyui wheel"
    "d /var/ai/comfyui/user 0770 comfyui wheel"
    "d /var/ai/comfyui/output 0770 comfyui wheel"

    "d /var/ai/toolkit 0770 root wheel"
    "d /var/ai/toolkit/datasets 0770 root wheel"
    "d /var/ai/toolkit/config 0770 root wheel"
    "d /var/ai/toolkit/output 0770 root wheel"

    "d /export/ai/comfyui 0770 comfyui ai"
    "Z /export/ai/comfyui 0770 comfyui ai"
    "d /export/ai/comfyui/custom_nodes 0770 comfyui ai"
    "d /export/ai/comfyui/models 0770 comfyui ai"
    "d /export/ai/comfyui/user 0770 comfyui ai"
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
    exports = "/export/ai x86-atxtwr-workstation(rw,nohide,insecure,no_subtree_check)";
  };

  virtualisation.oci-containers.containers = {
    comfyui = {
      image = "ghcr.io/siggnal460/comfyui-container-cuda:v3.3";
      autoStart = true;
      ports = [
        "8188:8188"
      ];
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      volumes = [
        "/export/ai/comfyui/custom_nodes:/app/custom_nodes:rw"
        "/export/ai/comfyui/models:/app/models:rw"
        "/export/ai/comfyui/user:/app/user:rw"
      ];
      environment = {
        PUID = "780";
        PGID = "780";
        COMFYUI_ARGS = "--max-upload-size 999999999";
      };
      extraOptions = [
        "--name=comfyui"
        "--gpus=all"
      ];
    };

    comfyui-local = {
      image = "ghcr.io/siggnal460/comfyui-container-cuda:v3.3";
      autoStart = true;
      ports = [
        "8189:8188"
      ];
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      volumes = [
        "/var/ai/comfyui/models:/app/models:rw"
        "/var/ai/comfyui/user:/app/user:rw"
        "/var/ai/comfyui/output:/app/output:rw"
        "/export/ai/comfyui/custom_nodes:/app/custom_nodes:rw"
      ];
      environment = {
        PUID = "780";
        PGID = "780";
        COMFYUI_ARGS = "--max-upload-size 999999999";
      };
      extraOptions = [
        "--name=comfyui-local"
        "--gpus=all"
      ];
    };

    ai-toolkit = {
      image = "docker.io/ostris/aitoolkit:latest";
      autoStart = true;
      ports = [
        "8675:8675"
      ];
      labels = {
        "io.containers.autoupdate" = "registry";
      };
      volumes = [
        "/root/.cache/huggingface/hub:/root/.cache/huggingface/hub"
        "/var/ai/toolkit/datasets:/app/ai-toolkit/datasets"
        "/var/ai/toolkit/output:/app/ai-toolkit/output"
        "/var/ai/toolkit/config:/app/ai-toolkit/config"
        "/var/ai/comfyui/models:/app/ai-toolkit/models"
        "/dev/shm:/dev/shm"
      ];
      extraOptions = [
        "--name=ai-toolkit"
        "--gpus=all"
        "--shm-size=2g"
      ];
    };
  };
}
