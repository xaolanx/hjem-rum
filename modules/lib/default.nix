{lib}: {
  # lib is extended under lib.rum due to annoyances with lib extensions
  # and also to maximize transparency of what is and isn't custom
  rum = {
    generators = import ./generators.nix {inherit lib;};
  };
}
