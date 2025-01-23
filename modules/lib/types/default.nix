{lib}: {
  gtkType = import ./gtkType.nix {inherit lib;};
  ncmpcppBindingType = import ./ncmpcppBindingType.nix {inherit lib;};
}
