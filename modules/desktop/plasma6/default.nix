{
  pkgs,
  ...
}:
{
  imports = [
    ./login-manager.nix
  ];

  services.desktopManager.plasma6.enable = true;
  environment.systemPackages = with pkgs; [
    aha
  ];
}
