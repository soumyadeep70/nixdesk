{
  lib,
  ...
}:
{
  perSystem =
    { pkgs, config, ... }:
    {
      devShells.default =
        let
          treefmt-wrapper = config.treefmt.build.wrapper or null;
          files-wrapper = config.files.writer.drv or null;
          pre-commit-script = config.pre-commit.installationScript or null;
        in
        pkgs.mkShell {
          packages =
            with pkgs;
            [
              nixd
              sops
              nh
              just
            ]
            ++ lib.optional (treefmt-wrapper != null) treefmt-wrapper
            ++ lib.optional (files-wrapper != null) files-wrapper;

          shellHook = ''
            ${lib.optionalString (pre-commit-script != null) ''
              ${pre-commit-script}
            ''}
          '';
        };
    };
}
