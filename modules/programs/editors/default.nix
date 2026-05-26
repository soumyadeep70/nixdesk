{
  pkgs,
  ...
}:
{
  imports = [
    ./vscode.nix
  ];

  # Allow CPU profiling
  boot.kernel.sysctl = {
    "kernel.perf_event_paranoid" = -1;
    "kernel.kptr_restrict" = 0;
  };

  environment.systemPackages = with pkgs; [
    antigravity-fhs
    zed-editor-fhs
    jetbrains.clion
  ];

}
