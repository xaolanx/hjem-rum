{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.options) mkOption mkEnableOption;
  inherit (lib.types) listOf package lines;
  inherit (lib.modules) mkIf;
  inherit (lib.rum.generators.gtk) toGtk2Text gtkType toGtkINI;
  inherit (lib.strings) hasPrefix;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.lists) optionals any;

  cfg = config.rum.gtk;
in {
  options.rum.gtk = {
    enable = mkEnableOption "GTK configuration";
    packages = mkOption {
      type = listOf package;
      default = [];
      example = [
        (pkgs.catppuccin-papirus-folders.override {
          accent = "rosewater";
          flavor = "mocha";
        })
        pkgs.bibata-cursors
      ];
      description = ''
        The list of packages to be installed for gtk themes.
        This list should consist of any packages that will be used
        by your GTK theme(s).
      '';
    };
    settings = mkOption {
      type = gtkType;
      default = {};
      example = {
        theme-name = "Arc-Dark";
        font-name = "Sans 11";
        application-prefer-dark-theme = true;
      };
      description = ''
        The settings that will be written to the various gtk files
        to configure the GTK theme. GTK documentation is perhaps
        nebulous, but the Arch Wiki entry and the official GTK
        documentation (https://docs.gtk.org/gtk3/class.Settings.html)
        are decent places to start.

        Please note that each option name will have "gtk-" prepended
        to it, so there is no need to include that on every single option.
      '';
    };
    css = {
      gtk3 = mkOption {
        type = lines;
        default = "";
        description = ''
          CSS to be written to '${config.directory}/.config/gtk-3.0/gtk.css'.
          You can either use this as lines or you can reference
          a CSS file from your theme's package (or both).
        '';
      };
      gtk4 = mkOption {
        type = lines;
        default = "";
        description = ''
          CSS to be written to '${config.directory}/.config/gtk-4.0/gtk.css'.
          You can either use this as lines or you can reference
          a CSS file from your theme's package (or both).
        '';
      };
    };
  };
  config = mkIf cfg.enable {
    warnings = let
      attrsHasPrefix = prefix: attrs: (any (hasPrefix prefix) (mapAttrsToList (n: _: n) attrs));
    in (optionals (attrsHasPrefix "gtk-" cfg.settings) [
      "You have prefixed 'gtk-' to an option in 'rum.gtk.settings'. This prefix is automatically included, and you should remove it from your declaration."
    ]);

    inherit (cfg) packages;

    files = mkIf (cfg.settings != {}) {
      ".gtkrc-2.0".text = toGtk2Text {inherit (cfg) settings;};
      ".config/gtk-3.0/settings.ini".text = toGtkINI {
        Settings = cfg.settings;
      };
      ".config/gtk-4.0/settings.ini".text = toGtkINI {
        Settings = cfg.settings;
      };
      ".config/gtk-3.0/gtk.css".text = mkIf (cfg.css.gtk3 != "") cfg.css.gtk3;
      ".config/gtk-4.0/gtk.css".text = mkIf (cfg.css.gtk4 != "") cfg.css.gtk4;
    };

    # Implement when hjem implements env vars
    /*
    environment.sessionVariables = {
      GTK2_RC_FILES = "${config.directory}/.gtkrc-2.0";
      GTK_THEME = cfg.theme.name;
    };
    */
  };
}
