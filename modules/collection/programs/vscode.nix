{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.types) attrsOf anything;
  inherit (builtins) toJSON;

  cfg = config.rum.programs.vscode;
in {
  options.rum.programs.vscode = {
    enable = mkEnableOption "Visual Studio Code";

    package = mkPackageOption pkgs "vscode" {};

    settings = mkOption {
      type = attrsOf anything;
      default = {};
      example = {
        "editor.fontFamily" = "Fira Code Nerdfont";
        "editor.fontLigatures" = true;
        "workbench.colorTheme" = "Catppuccin Mocha";
        "catppuccin"."accentColor" = "red";
      };
      description = ''
        The configuration converted into JSON and written to
        `${config.directory}/.config/Code/User/settings.json`.

        Please reference https://code.visualstudio.com/docs/getstarted/settings#_settings-json-file
        for more info.
      '';
    };
  };

  config = mkIf cfg.enable {
    packages = [cfg.package];
    files = {
      ".config/Code/User/settings.json".text = mkIf (cfg.settings != {}) (
        toJSON cfg.settings
      );
    };
  };
}
