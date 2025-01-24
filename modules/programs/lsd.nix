{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.types) attrsOf either int str lines;

  cfg = config.rum.programs.lsd;
  toYAML = pkgs.formats.yaml {};
in {
  options.rum.programs.lsd = {
    enable = mkEnableOption "lsd";

    package = mkPackageOption pkgs "lsd" {};

    settings = mkOption {
      type = toYAML.type;
      default = {};
      example = {
        classic = false;
	color = {
	  theme = "default";
	};
      };

      description = ''
        Configuration written to `${config.directory}/.config/lsd/config.yaml`.
        Please reference https://github.com/lsd-rs/lsd#config-file-content to configure it accordingly.
      '';
    };
  };

  config = mkIf cfg.enable {
    packages = [
      cfg.package
    ];
    files.".config/lsd/config.yaml".source = toYAML.generate "config.yaml" cfg.settings;
  };
}
