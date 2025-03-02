{lib}: let
  inherit (lib.types) attrsOf listOf oneOf bool float int path str;

  hyprValue = oneOf [str path bool int float hyprList hyprMap];
  hyprMap = attrsOf hyprValue;
  hyprList = listOf hyprValue;
in
  hyprMap
