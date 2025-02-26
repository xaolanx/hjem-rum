{lib}: let
  inherit (lib.types) attrsOf oneOf str path bool int float;
in (
  attrsOf (oneOf [
    str
    path
    bool
    int
    float
  ])
)
