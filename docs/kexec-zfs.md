# Custom kexec installer with stable ZFS

Status: **in progress**
Scope: `flake.nix` (inputs + `packages`), consumption via nixos-anywhere.

## Goal

Build a `kexec-installer-nixos-unstable-zfs` tarball from this repo's
`flake.nix`, inlined (no new module files), reusing
[nixos-images](https://github.com/nix-community/nixos-images) modules.
It must use **stable ZFS 2.4** on a recent kernel — same pairing as
`hosts/hammer/zfs.nix` (`linux_7_2` + `zfs_2_4`) — **not** `zfs_unstable`.

## Decisions

1. `nixos-images` is a flake input; its `nixos-unstable` input
   `follows = "nixpkgs-unstable"` so we share one nixpkgs tree (verified in
   `flake.lock`: `nixos-images/nixos-unstable` follows `nixpkgs-unstable`).
2. Reuse modules from the input, inline only the variant-specific attrs:
   - `inputs.nixos-images.nixosModules.kexec-installer`
   - `inputs.nixos-images + /nix/latest-zfs-kernel.nix`
   - `inputs.nixos-images + /nix/zfs-minimal.nix` — **rejected**: hardcodes
     `pkgs.zfs_unstable` + `kernelPackages.zfs_unstable`.
3. `packages` replaces the old `import ./pkgs` (stale artifact, commented
   out for now). Restricted to `aarch64-linux` / `x86_64-linux` via
   `lib.optionalAttrs` since nixos-images only supports those.
4. `installer.nix` (pulled in by the kexec module) sets
   `boot.zfs.package = pkgs.zfs_unstable`; our inline module must override
   it (`lib.mkForce`) and set `boot.supportedFilesystems = [ "zfs" ]` +
   `networking.hostId`.
5. `latest-zfs-kernel.nix` picks the newest kernel whose zfs module isn't
   broken, keyed on `pkgs.zfs.kernelModuleAttribute` when
   `boot.zfs.package != pkgs.zfs_unstable`. Need to verify the picked
   kernel actually provides `zfs_2_4` (hammer pins `linux_7_2`); if not,
   pin `boot.kernelPackages = pkgs.linuxKernel.packages.linux_7_2` and
   `boot.zfs.package = pkgs.linuxKernel.packages.linux_7_2.zfs_2_4`
   explicitly, like hammer does.

## Progress

- [x] Input added + locked; follows verified.
- [x] `packages = forAllSystems ...` inline in `flake.nix`;
      `kexec-installer-nixos-unstable-zfs` evaluates on both systems
      (`drvPath` OK) — but still imports `zfs-minimal.nix` (zfs_unstable).
- [ ] Replace `zfs-minimal.nix` with `latest-zfs-kernel.nix` + stable zfs
      package as per decisions 4–5.
- [ ] Re-eval both systems; check selected kernel/zfs in the built drv.
- [ ] (optional) full `nix build` smoke test.

## Usage (nixos-anywhere)

Per <https://nix-community.github.io/nixos-anywhere/howtos/custom-kexec.html>:

```sh
nixos-anywhere \
  --kexec "$(nix build --print-out-paths \
    .#packages.x86_64-linux.kexec-installer-nixos-unstable-zfs)/**nixos-kexec-installer-zfs-x86_64-linux.tar.gz**" \
  --flake '.#<host>' root@<ip>
```

Tarball name inside the output dir is
`${system.kexec-installer.name}-${system}.tar.gz` (we set
`name = "nixos-kexec-installer-zfs"`).
