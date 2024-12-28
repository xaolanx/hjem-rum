{
  description = "A module collection for hjem.";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    #nixpkgs,
    ...
  }: {
    nixosModules = {
      hjem-rum = import ./modules/nixos.nix;
      default = self.nixosModules.hjem-rum;
    };
  };
}
