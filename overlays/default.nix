{
  inputs,
  ...
}:
{

  unstable-pkgs = (
    final: _prev: {
      unstable = import inputs.nixpkgs-unstable {
        inherit (final) config overlays;
        system = final.stdenv.hostPlatform.system;
      };
    }
  );

  mypkgs = (
    final: _prev: {
      m = inputs.nix-packages.packages.${final.stdenv.hostPlatform.system};
    }
  );

  rocm-only-gfx1151 = (
    final: prev: {
      rocmPackages = prev.rocmPackages.overrideScope (
        rocmFinal: rocmPrev: {
          clr = rocmPrev.clr.override {
            localGpuTargets = [ "gfx1151" ];
          };
        }
      );
    }
  );

}
