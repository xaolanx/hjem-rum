{lib}: let
  inherit (builtins) map isList toString;
  inherit (lib.attrsets) mapAttrsToList;
  inherit (lib.strings) concatStringsSep;

  toEnvValue = env:
    if isList env
    then concatStringsSep ":" (map toString env)
    else toString env;

  toEnvExport = vars: (concatStringsSep "\n"
    (mapAttrsToList
      (name: value: "export ${name}=\"${toEnvValue value}\"")
      vars));
in {
  inherit toEnvExport toEnvValue;
}
