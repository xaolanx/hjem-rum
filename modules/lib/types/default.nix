{lib}: {
  gtkType = import ./gtkType.nix {inherit lib;};
  tofiSettingsType = import ./tofiSettingsType.nix {inherit lib;};
}
