{lib}: {
  # Import the hjem-rum module collection as an extraModule passed into `hjem.users.<username>`
  # This allows the definition of rum modules under `hjem.users.<username>.rum`
  hjem = {
    extraModules = [
      {
        imports = lib.filesystem.listFilesRecursive ./collection;
      }
    ];
    specialArgs = {inherit lib;};
  };
}
