{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption mkEnableOption mkPackageOption;
  inherit (lib.types) listOf package;

  cfg = config.rum.programs.obs-studio;
in {
  options.rum.programs.obs-studio = {
    enable = mkEnableOption "obs-studio";

    package = mkPackageOption pkgs "obs-studio" {};

    plugins = mkOption {
      type = listOf package;
      default = [];
      example = [
        pkgs.obs-studio-plugins.wlrobs #for screen capture w/wayland
        pkgs.obs-studio-plugins.obs-vkcapture #vulkan/opengl game capture
      ];

      description = ''
        A list of plugins the obs-studio package will be wrapped with.
        Set of plugins available in nixpkgs under the obs-studio-plugins set.
      '';
    };
  };

  config = mkIf cfg.enable {
    packages = [
      (pkgs.wrapOBS.override {obs-studio = cfg.package;} {
        plugins = cfg.plugins;
      })
    ];
  };
}
