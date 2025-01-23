{
  description = "A module collection for Hjem";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    ...
  }: let
    forAllSystems = nixpkgs.lib.genAttrs ["x86_64-linux" "aarch64-linux"];
    extendedLib = nixpkgs.lib.extend (final: prev: import ./modules/lib/default.nix {lib = prev;});
  in {
    nixosModules = {
      hjem-rum = import ./modules/nixos.nix {inherit (nixpkgs) lib;};
      default = self.nixosModules.hjem-rum;
    };

    specialArgs = {lib = extendedLib;};

    # Provide the default formatter to invoke on 'nix fmt'.
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
  };
}
