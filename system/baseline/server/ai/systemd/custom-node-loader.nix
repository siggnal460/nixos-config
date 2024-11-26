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
      custom_node_dir="/export/ai/appdata/comfyui/custom_nodes"
      for dir in $custom_node_dir; do
      		if [ -d "$dir/.git" ]; then
      				echo "Pulling changes in $dir"
      				(cd "$dir" && git pull)
      		fi
      done
      cd $custom_node_dir
      ${cloneUrl}
    '';
  node_files = [
    "https://github.com/Acly/comfyui-tooling-nodes"
    "https://github.com/Acly/comfyui-inpaint-nodes"
    "https://github.com/cubiq/ComfyUI_IPAdapter_plus"
    "https://github.com/Fannovel16/comfyui_controlnet_aux"
  ];
in
{
  systemd.services.custom-node-loader = {
    description = "ComfyUI custom node background download";
    wantedBy = [
      "multi-user.target"
    ];
    after = [ "systemd-tmpfiles-setup.service" ];
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
