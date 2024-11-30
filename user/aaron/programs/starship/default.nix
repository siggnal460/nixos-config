{ lib, ... }:
let
  black = "#1a1b26";
  darkest_bg = "#343955";
  darker_bg = "#394260";
  dark_bg = "#414868";
  mid_bg = "#454c6e";
  light_bg = "#565f89";
  lightest_bg = "#c0caf5";
  fg = "#a9b1d6";
  red = "#f7768e";
  orange = "#ff9e64";
  green = "#9ece6a";
  cyan = "#2ac4de";
  turquoise = "#73daca";
  blue = "#7aa2f7";
  purple = "#bb9af7";
in
{
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      format = lib.concatStrings [
        "[ 󱄅 ](bold bg:${lightest_bg} fg:${black})"
        "$character"
        "$hostname"
        "$git_branch"
        "$git_status"
        "$golang"
        "$python"
        "$rust"
        "$directory"
        "$time"
        "\n  "
      ];

      hostname = {
        style = "fg:${fg} bg:${mid_bg}";
        format = "[ [](fg:${cyan} bg:${mid_bg}) $hostname ]($style)";
      };

      git_branch = {
        symbol = "";
        style = "fg:${fg} bg:${dark_bg}";
        format = "[ [$symbol](fg:${purple} bg:${dark_bg}) $branch ]($style)";
      };

      git_status = {
        style = "fg:${fg} bg:${dark_bg}";
        format = "[($all_status$ahead_behind )]($style)";
      };

      golang = {
        symbol = "";
        style = "fg:${fg} bg:${darker_bg}";
        format = "[ $symbol ($version) ]($style)";
      };

      python = {
        symbol = "";
        style = "fg:${fg} bg:${darker_bg}";
        format = "[ $symbol ($version) ]($style)";
      };

      rust = {
        symbol = "";
        style = "fg:${fg} bg:${darker_bg}";
        format = "[ $symbol ($version) ]($style)";
      };

      directory = {
        style = "fg:${fg} bg:${darker_bg}";
        format = "[ [󰉋](fg:${blue} bg:${darker_bg}) $path ]($style)[$read_only]($read_only_style)";
        read_only = "󰌾 ";
        read_only_style = "fg:${orange} bg:${darker_bg}";
      };

      directory.substitutions = {
        "Documents" = "󰈙 ";
        "Downloads" = " ";
        "Music" = " ";
        "Pictures" = " ";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "fg:${fg} bg:${darkest_bg}";
        format = "[ [](fg:${turquoise} bg:${darkest_bg}) $time ]($style)";
      };

      character = {
        format = "$symbol";
        success_symbol = "[  ](fg:${green} bg:${light_bg})";
        error_symbol = "[  ](fg:${red} bg:${light_bg})";
      };
    };
  };
}
