{lib}: {
  # These functions are inspired by home-manager's gtk generators.
  gtk = let
    inherit (builtins) isBool isString toString;
    inherit (lib.strings) hasPrefix concatStringsSep;
    inherit (lib.attrsets) mapAttrsToList;
    inherit (lib.trivial) boolToString;
    inherit (lib.generators) toINI;
    inherit (lib.types) attrsOf oneOf bool int float str;
  in {
    gtkType = attrsOf (oneOf [
      bool
      int
      float
      str
    ]);
    toGtk2Text = let
      formatGtk2 = n: v: let
        n' = "gtk-" + n;
        v' =
          if isBool v
          then boolToString v
          else if isString v
          then
            if hasPrefix "GTK_" v
            then v
            else ''"${v}"''
          else toString v;
      in "${n'}=${v'}";
    in
      {settings}: concatStringsSep "\n" (mapAttrsToList formatGtk2 settings);
    toGtkINI = attrs:
      toINI {
        mkKeyValue = n: v: let
          n' = "gtk-" + n;
          v' =
            if isBool v
            then boolToString v
            else toString v;
        in "${n'}=${v'}";
      }
      attrs;
  };
}
