{lib}: let
  inherit (builtins) any;
  inherit (lib.attrsets) filterAttrs;
  inherit (lib.strings) hasPrefix;
in
  /*
  Filters an attribute set with prefixes applied to keys.

  # Inputs

  `prefixes`

  : A list of prefixes to filter the attribute set with.

  `attrs`

  : The attribute set to apply the filter on.

  Value
  : The filtered attribute set.
  */
  prefixes: attrs:
    if prefixes == []
    then attrs
    else
      filterAttrs
      (name: _: any (prefix: hasPrefix prefix name) prefixes)
      attrs
