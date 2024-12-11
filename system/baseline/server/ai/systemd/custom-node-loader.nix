{ pkgs, lib, ... }:
let
  cloneFiles =
    repos:
    let
      cloneUrl = lib.concatStringsSep "\n" (
        map (repo: "${pkgs.git}/bin/git clone ${repo} || true") repos
      );
    in
    ''
      		  comfyui_dir="/export/ai/appdata/comfyui"
            cd $comfyui_dir/custom_nodes
            ${cloneUrl}
            for dir in $comfyui_dir/custom_nodes; do
      			    chmod 0775 -R $dir
            		if [ -d "$dir/.git" ]; then
            				echo "Pulling changes in $dir"
            				(cd "$dir" && git pull)
            		fi
            done
    '';
  node_files = [ "https://github.com/Fannovel16/comfyui_controlnet_aux" ];
in
{
  systemd.services.custom-node-loader = {
    description = "ComfyUI custom node background download";
    wantedBy = [ "multi-user.target" ];
    after = [
      "systemd-tmpfiles-setup.service"
      "podman-comfyui.service"
    ];
    serviceConfig = {
      Type = "exec";
      Restart = "on-failure";
      RestartSec = "1s";
      RestartMaxDelaySec = "2h";
      RestartSteps = "10";
    };

    script = "${cloneFiles node_files}";
  };
}
