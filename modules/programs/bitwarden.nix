{
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.bitwarden-desktop
    pkgs.bitwarden-cli
  ];
}
