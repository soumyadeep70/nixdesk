{
  lib,
  inputs,
  self,
  withSystem,
  ...
}:
let
  repoRoot = builtins.getEnv "NIXDESK_ROOT";
  hosts = builtins.attrNames (lib.filterAttrs (_: type: type == "directory") (builtins.readDir ./.));
in
{
  flake.nixosConfigurations = lib.genAttrs hosts (
    name:
    let
      arch = builtins.readFile ./${name}/.arch;
    in
    inputs.nixpkgs.lib.nixosSystem (
      withSystem arch (
        { self', inputs', ... }:
        {
          specialArgs = {
            inherit inputs self;
            inherit repoRoot;
          };

          modules = [
            {
              _module.args = { inherit self' inputs'; };
              nixpkgs.hostPlatform = arch;

              # hardcoded hostname
              networking.hostName = name;
            }
            ./${name}
            ./../secrets
          ];
        }
      )
    )
  );
}
