{ pkgs, lib, ... }:
let
  git = "${pkgs.git}/bin/git";
  cloneRepos =
    repos:
    let
      cloneRepo = lib.concatStringsSep "\n" (
        map (repo: "${git} clone ${repo} 2>/dev/null || echo \"Did not clone ${repo}\"") repos
      );
    in
    ''
      comfyui_dir="/export/ai/appdata/comfyui"
      cd $comfyui_dir/custom_nodes || echo "Could not enter comfyui custom_nodes directory"
      ${cloneRepo}
      for dir in "$comfyui_dir/custom_nodes"/*/; do
      	if [ -d "$dir/.git" ]; then
      		chown :users -R $dir || echo "Could not changed ownership permissions of $dir"
      		chmod 0770 -R $dir || echo "Could not changed permissions to 0770 of $dir"
      		echo "Pulling changes in $dir"
      		cd "$dir" || echo "Could not enter directory $dir"
      		${git} pull || echo "Could not git pull directory $dir"
      	fi
      done
    '';
  node_files = [
    "https://github.com/ltdrdata/ComfyUI-Manager"
    "https://github.com/Fannovel16/comfyui_controlnet_aux"
    "https://github.com/cubiq/ComfyUI_IPAdapter_plus"
    "https://github.com/Acly/comfyui-inpaint-nodes"
    "https://github.com/Acly/comfyui-tooling-nodes"
  ];
in
{
  systemd.services.custom-node-loader = {
    description = "ComfyUI custom node background download";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-tmpfiles-setup.service" ];
    onSuccess = [ "podman-comfyui.service" ];
    serviceConfig = {
      Type = "exec";
      Restart = "on-failure";
      RestartSec = "1s";
      RestartMaxDelaySec = "2h";
      RestartSteps = "10";
    };

    script = "${cloneRepos node_files}";
  };
}
