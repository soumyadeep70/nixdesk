{
  inputs,
  lib,
  ...
}:
{
  flake.overlays.default = _final: prev: {

    intel-media-sdk = prev.intel-media-sdk.overrideAttrs (old: {
      stdenv = prev.gcc13Stdenv;
      doCheck = false;
      cmakeFlags = (old.cmakeFlags or [ ]) ++ [
        "-DBUILD_TESTS=OFF"
        "-DBUILD_SAMPLES=OFF"
      ];
    });

    disblock-origin = prev.stdenvNoCC.mkDerivation {
      pname = "disblock-origin";
      version = inputs.disblock-origin.shortRev;
      src = inputs.disblock-origin.outPath;

      installPhase = ''
        mkdir -p $out/share
        cp -r $src/. $out/share/
      '';

      meta = {
        description = "An ad-blocker \"Theme\" for Discord that hides all Nitro and \"boost\" upsells, alongside some annoyances.";
        homepage = "https://codeberg.org/AllPurposeMat/Disblock-Origin.git";
        maintainers = with lib.maintainers; [ soumyadeep70 ];
        platforms = lib.platforms.all;
      };
    };
  };
}
