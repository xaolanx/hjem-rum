{lib}: let
  inherit (lib.attrsets) filterAttrs attrNames;
  inherit (lib.trivial) pipe;
  inherit (builtins) readDir;
in {
  config = {
    # Import the hjem-rum module collection as an extraModule passed into `hjem.users.<username>`
    # This allows the definition of rum modules under `hjem.users.<username>.rum`
    hjem.extraModules = [
      {
        imports = pipe ./programs [
          readDir
          (filterAttrs (_: v: v == "regular"))
          attrNames
          (map (n: ./programs/${n}))
        ];
      }
    ];
  };
}
