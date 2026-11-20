{ pkgs, ... }:
{
  # We theme with the real "Tokyo Night" extension/theme below rather than
  # stylix's generated base16 theme.
  stylix.targets.vscode.enable = false;

  programs.vscode = {
    enable = true;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        enkia.tokyo-night
        anthropic.claude-code
        ms-python.python
        ms-python.debugpy
        ms-python.vscode-pylance
        ms-azuretools.vscode-containers
        ms-vscode-remote.remote-containers
      ];

      keybindings = [
        {
          key = "ctrl+shift+/";
          command = "-workbench.action.chat.focusTip";
          when = "inChat || inChat && inChatTip";
        }
        {
          key = "ctrl+shift+/";
          command = "claude-vscode.focus";
          when = "editorTextFocus && !config.claudeCode.useTerminal";
        }
        {
          key = "ctrl+escape";
          command = "-claude-vscode.focus";
          when = "editorTextFocus && !config.claudeCode.useTerminal";
        }
        {
          key = "ctrl+shift+/";
          command = "claude-vscode.blur";
          when = "!config.claudeCode.useTerminal && !editorTextFocus";
        }
        {
          key = "ctrl+escape";
          command = "-claude-vscode.blur";
          when = "!config.claudeCode.useTerminal && !editorTextFocus";
        }
      ];

      userSettings = {
        "workbench.colorTheme" = "Tokyo Night";
        "workbench.editor.showTabs" = "single";
        "files.autoSave" = "afterDelay";
        "git.autofetch" = true;

        "editor.lineNumbers" = "relative";
        "vim.smartRelativeLine" = true;

        "claudeCode.preferredLocation" = "panel";
        "claudeCode.hideOnboarding" = true;

        "python.analysis.typeCheckingMode" = "basic";

        "containers.containerClient" = "com.microsoft.visualstudio.containers.podman";
        "containers.orchestratorClient" = "com.microsoft.visualstudio.orchestrators.podmancompose";
        "dev.containers.dockerPath" = "podman";
        "dev.containers.dockerComposePath" = "podman-compose";
        "dev.containers.dockerSocketPath" = "/run/user/1000/podman/podman.sock";
      };
    };
  };
}
