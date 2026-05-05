{
  inputs,
  ...
}:
{
  imports = with inputs; [ git-hooks.flakeModule ];

  perSystem =
    { config, pkgs, ... }:
    {
      pre-commit.settings =
        let
          treefmt-wrapper = config.treefmt.build.wrapper or null;
        in
        {
          excludes = [ "flake.lock" ];

          hooks = {
            treefmt.enable = if (treefmt-wrapper != null) then true else false;
            treefmt.package = if (treefmt-wrapper != null) then treefmt-wrapper else pkgs.treefmt;
          };
        };
    };
}
