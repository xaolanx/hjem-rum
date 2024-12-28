{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.options) mkOption literalExpression;
  inherit (lib.types) package attrs;

  toTOML = (pkgs.formats.toml {}).generate;

  cfg = config.rum.programs.alacritty;
in {
  options.rum.programs.alacritty = {
    enable = mkEnableOption "Alacritty";

    package = mkOption {
      type = package;
      default = pkgs.alacritty;
      description = "The nix package to be installed.";
    };

    settings = mkOption {
      type = attrs;
      default = {};
      example = literalExpression ''
        window = {
          dimensions = {
            lines = 28;
            columns = 101;
          };
          padding = {
            x = 6;
            y = 3;
          };
        };
      '';
      description = ''
        The configuration converted into TOML and written to
        `${config.directory}/.config/alacritty/alacritty.toml`.
        Please reference https://alacritty.org/config-alacritty.html
        for config options.
      '';
    };
  };

  config = mkIf cfg.enable {
    packages = [ cfg.package ];
    files.".config/alacritty/alacritty.toml".source = toTOML "alacritty.toml" cfg.settings;
  };
}
