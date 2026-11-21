{ pkgs, ... }:
{
  # We theme with the real "Tokyo Night" extension/theme below rather than
  # stylix's generated base16 theme.
  stylix.targets.vscode.enable = false;

  programs.vscode = {
    enable = true;

    # Only extensions declared below are loaded; nothing can be installed
    # out-of-band through the Extensions view, keeping the setup reproducible.
    mutableExtensionsDir = false;

    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
        enkia.tokyo-night
        anthropic.claude-code
        ms-python.python
        ms-python.debugpy
        ms-python.vscode-pylance
        ms-python.vscode-python-envs
        ms-azuretools.vscode-containers
        ms-vscode-remote.remote-containers
        thenuprojectcontributors.vscode-nushell-lang
        jnoortheen.nix-ide
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
        # Disable Microsoft telemetry/spying and anything copilot-related,
        # since Claude Code is used for AI assistance instead.
        "telemetry.telemetryLevel" = "off";
        "telemetry.enableTelemetry" = false;
        "telemetry.enableCrashReporter" = false;
        "update.mode" = "none";
        "update.showReleaseNotes" = false;
        "extensions.autoCheckUpdates" = false;
        "extensions.autoUpdate" = false;
        "extensions.ignoreRecommendations" = true;
        "workbench.enableExperiments" = false;
        "workbench.settings.enableNaturalLanguageSearch" = false;
        "workbench.editor.experimentalCustomEditors" = false;
        "github.copilot.enable" = {
          "*" = false;
        };
        "redhat.telemetry.enabled" = false;
        "python.experiments.enabled" = false;
        "workbench.colorTheme" = "Tokyo Night";
        "workbench.editor.showTabs" = "single";
        "files.autoSave" = "afterDelay";
        "files.autoSaveWorkspaceFilesOnly" = true;
        "git.autofetch" = true;

        "editor.lineNumbers" = "relative";
        "vim.smartRelativeLine" = true;

        "claudeCode.preferredLocation" = "panel";
        "claudeCode.hideOnboarding" = true;

        "python.analysis.typeCheckingMode" = "basic";

        "nix.enableLanguageServer" = true;
        "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
        "nix.formatterPath" = "${pkgs.nixfmt}/bin/nixfmt";

        # /nix/store and flake result symlinks churn the file watcher/search
        # index for no benefit; they're build outputs, not source.
        "files.watcherExclude" = {
          "**/result" = true;
          "**/result-*" = true;
          "/nix/store/**" = true;
        };
        "search.exclude" = {
          "**/result" = true;
          "**/result-*" = true;
          "/nix/store/**" = true;
        };

        "containers.containerClient" = "com.microsoft.visualstudio.containers.podman";
        "containers.orchestratorClient" = "com.microsoft.visualstudio.orchestrators.podmancompose";
        "dev.containers.dockerPath" = "podman";
        "dev.containers.dockerComposePath" = "podman-compose";
        "dev.containers.dockerSocketPath" = "/run/user/1000/podman/podman.sock";
      };
    };
  };
}
