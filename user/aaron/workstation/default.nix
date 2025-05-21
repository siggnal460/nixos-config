{
  users.users.aaron.extraGroups = [ "libvirtd" ];

  systemd = {
    tmpfiles.rules = [
		  "d /home/aaron/AI 0700 aaron aaron"
		  "d /home/aaron/AI/comfyui 0700 aaron aaron"
		  "d /home/aaron/AI/comfyui/input 0700 aaron aaron"
		  "d /home/aaron/AI/comfyui/output 0700 aaron aaron"
		  "d /home/aaron/AI/comfyui/models 0700 aaron aaron"
		  "d /home/aaron/AI/comfyui/workflows 0700 aaron aaron"
		  "d /home/aaron/Blender 0700 aaron aaron"
		  "d /home/aaron/Blender/addons 0700 aaron aaron"
		  "d /home/aaron/Blender/models 0700 aaron aaron"
		  "d /home/aaron/Blender/models/male 0700 aaron aaron"
		  "d /home/aaron/Blender/models/female 0700 aaron aaron"
		  "d /home/aaron/Blender/models/objects 0700 aaron aaron"
		  "d /home/aaron/Blender/environments 0700 aaron aaron"
		  "d /home/aaron/Projects 0700 aaron aaron"
		  "d /home/aaron/Projects/go 0700 aaron aaron"
		  "d /home/aaron/Projects/python 0700 aaron aaron"
		  "d /home/aaron/Projects/lua 0700 aaron aaron"
		];
  };

  home-manager.users.aaron = {
    imports = [
      ./programs/mpv
      ./programs/librewolf
    ];

    accounts.email.accounts.aaron.thunderbird.enable = true;

    dconf.settings = {
      # connects virt-manager to qemu
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [ "qemu:///system" ];
        uris = [ "qemu:///system" ];
      };
    };

    fonts.fontconfig.enable = true;
  };
}
