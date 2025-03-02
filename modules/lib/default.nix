{lib}: let
  inherit (lib.trivial) pipe;
  inherit (lib.strings) removeSuffix;
  inherit (lib.attrsets) mapAttrs' nameValuePair;
  inherit (builtins) readDir;

  /*
  Reworked version of 'listFilesRecursive', that instead creates a nested attrset defining the location
  of an imported nix file.


  # Inputs

  `path`

  : The path to recursively create an attrset from..

  # Type

  ```
  Path -> AttrSet
  ```
  */
  importFilesRecursive = path:
    pipe path [
      readDir

      /*
      This is where the "recursive" part of the name comes from. Basically, files are modified as attrs so
      that name is the name of the function, and value is their file imported. Directories are instead
      recursed into, with path extended accordingly. Ultimately, the location of each function is charted
      as it recurses.
      */
      (mapAttrs' (
        name: type:
          if type == "directory"
          then nameValuePair name (importFilesRecursive (path + "/${name}"))
          else
            nameValuePair (
              removeSuffix ".nix" name
            ) (
              import (path + "/${name}") {inherit lib;}
            )
      ))
    ];
in {
  /*
  'lib' is extended under 'lib.rum' due to annoyances with lib extensions, and also to maximize transparency
  of what is and isn't custom
  */
  rum = importFilesRecursive ./rum;
  /*
  We use a custom function, 'importFilesRecursive' to import our
  extended library functions recursively and simply. This eases
  the infrastructure burden of a growing extended library for
  both maintainers and contributors and ultimately allows more
  freedom in how we manage the library.

  Contributors: to add a custom function, simply add a nix file
  in the location where you want your function accessible, with
  its name chosen accordingly. For example, to have a function
  'lib.rum.generators.toTargetLang', you should create
  'lib/rum/generators/toTargetLang.nix', with the following schema:
  {lib}: let ... in arg: <function-code>;

  Additionally, here is the end product of 'importFilesRecursive'
  for transparency and to aid those of you looking for extending
  lib in your own flakes.

    # Example Directory Structure
    lib/
      default.nix
      rum/
        generators/
          gtk.nix
          hypr.nix
        types/
          gtkType.nix
          hyprType.nix

    # lib/default.nix
      {lib}: {
        rum = {
          generators = {
            gtk = import ./rum/generators/gtk.nix {inherit lib;};
            hypr = import ./rum/generators/hypr.nix {inherit lib;};
          };
          types = {
            gtkType = import ./rum/types/gtkType.nix {inherit lib;};
            hyprType = import ./rum/types/hyprType.nix {inherit lib;};
          };
        };
      }
  */
}
