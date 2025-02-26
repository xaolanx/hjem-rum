{lib}: let
  inherit (lib.types) attrsOf oneOf bool int float str;
in (attrsOf (oneOf [
  bool
  int
  float
  str
]))
