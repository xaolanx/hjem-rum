{
  lib,
  rumLib,
}: {
  # Import the hjem-rum module collection as an extraModule passed into `hjem.users.<username>`
  # This allows the definition of rum modules under `hjem.users.<username>.rum`
  hjem = {
    extraModules = [
      {
        imports = lib.filesystem.listFilesRecursive ./collection;
      }
    ];
    specialArgs = {inherit lib rumLib;};
  };

  warnings = ["The Hjem Rum NixOS Module is soon to be deprecated in favor of a Hjem Module. Please check the updated README for more information."];
}
