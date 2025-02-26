{lib}: {
  gtk = import ./gtk.nix {inherit lib;};
  ncmpcpp = import ./ncmpcpp.nix {inherit lib;};
}
