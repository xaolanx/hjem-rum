{lib}: {
  gtk = import ./gtk.nix {inherit lib;};
  ncmpcpp = import ./ncmpcpp.nix {inherit lib;};
  hypr = import ./hypr.nix {inherit lib;};
}
