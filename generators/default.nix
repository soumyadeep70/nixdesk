{
  inputs,
  lib,
  self,
  ...
}:
{
  imports = [
    inputs.files.flakeModules.default
  ];

  perSystem =
    {
      pkgs,
      inputs',
      self',
      ...
    }:
    {
      files.files = [
        (
          let
            system = lib.nixosSystem {
              inherit (pkgs.stdenv.hostPlatform) system;

              specialArgs = {
                inherit inputs self;
                inherit inputs' self';
              };

              modules = [
                self.nixosModules.default
              ];
            };

            docs = pkgs.nixosOptionsDoc {
              options = system.options.nixdesk;
            };

            content = builtins.replaceStrings [ "[${toString self}/" "(file://${toString self}/" ] [ "[" "(" ] (
              builtins.readFile docs.optionsCommonMark
            );
          in
          {
            path_ = "OPTIONS.md";
            drv = pkgs.writeText "-" content;
          }
        )
        (
          let
            existing_hosts = builtins.attrNames (
              lib.filterAttrs (_: type: type == "directory") (builtins.readDir ../hosts)
            );

            content =
              builtins.replaceStrings
                [
                  "__EXISTING_HOSTS__"
                ]
                [
                  (lib.concatStringsSep ", " existing_hosts)
                ]
                (builtins.readFile ./_README_.md);
          in
          {
            path_ = "README.md";
            drv = pkgs.writeText "-" content;
          }
        )
      ];
    };
}
