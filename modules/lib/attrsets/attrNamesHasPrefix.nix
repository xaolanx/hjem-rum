{lib}: let
  inherit (lib.strings) hasPrefix;
  inherit (lib.lists) any;
  inherit (builtins) attrNames;
in
  # Super simple function to check if any attributes' names
  # in the input attrset contain the input prefix
  prefix: attrs: (
    any (hasPrefix prefix) (attrNames attrs)
  )
