{
  inputs,
  ...
}:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem = _: {
    treefmt = {
      projectRootFile = "flake.nix";

      programs = {
        deadnix.enable = true;
        statix.enable = true;
        nixfmt.enable = true;
        mdformat = {
          enable = true;
          includes = [
            "generators/**/*.md"
          ];
        };
        actionlint.enable = true;
      };
    };
  };
}
