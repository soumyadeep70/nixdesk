{
  pkgs,
  ...
}:
{
  # Allow CPU profiling
  boot.kernel.sysctl = {
    "kernel.perf_event_paranoid" = -1;
    "kernel.kptr_restrict" = 0;
  };

  environment.systemPackages = [
    pkgs.zed-editor-fhs
    pkgs.jetbrains.clion
  ];

}
