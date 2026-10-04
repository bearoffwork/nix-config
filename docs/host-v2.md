# Host v2: `_system.nix` auto-enumeration

Status: **planned, not implemented**
Scope: `hosts/default.nix`, three new scaffold hosts, `flake.nix` wiring.

This document is self-contained so a fresh session can implement it without
any prior chat history.

## Goal

Replace the currently-unused, stale `hosts/default.nix` (a leftover copy of
the `modules/top-level/all-modules.nix` module-enumeration pattern) with a
new one that:

1. Scans `hosts/` for directories.
2. For each directory that contains a `_system.nix`, imports it to get a
   small "system config" (`sysBuilder` + `modules`).
3. Calls `sysBuilder` with `modules` and `specialArgs = { inherit inputs
   outputs; }` to produce a built NixOS configuration.
4. Returns a flat attrset `{ <hostDirName> = <builtConfiguration>; ... }`
   suitable for assigning directly to `nixosConfigurations` in `flake.nix`.

This lets adding a new host become "create `hosts/<name>/_system.nix` (and
whatever modules it imports)" with zero edits to `flake.nix` or
`hosts/default.nix`.

## Current state (verified facts, do not re-derive)

- `hosts/default.nix` exists but is dead code: it's a stray copy of the
  `enumerateModules` logic from `modules/top-level/all-modules.nix`, pointed
  at `../by-name`. It is not imported anywhere currently.
- `modules/top-level/all-modules.nix` is the reference pattern to mirror
  stylistically (readDir + filterAttrs for dirs, `pathExists` to skip
  incomplete entries, small pure helper function).
- No host directory currently has a `_system.nix`. Existing host dirs (all
  untouched by this work): `beacon`, `bench`, `booth`, `chisel`, `fusion`,
  `grind`, `hoard`, `hydrus`, `installer`, `rosetta`. Each has its own
  `default.nix` (the actual NixOS module), plus assorted host-specific
  files.
- `flake.nix` currently hand-builds exactly one configuration:
  ```nix
  nixosConfigurations.rosetta = inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs outputs; };
    modules = [
      ./hosts/rosetta
    ];
  };
  ```
  This block is the reference for what `specialArgs` and `modules` shape a
  built config expects.
- `flake.nix` inputs: `nixpkgs` (nixos-26.05), `nixpkgs-unstable`,
  `nixos-hardware`, `home-manager`, `sops-nix`, `llama-fork`. No
  `nix-darwin` input exists, so **NixOS only** — no need to support
  `darwinConfigurations`.
- `lib` in `flake.nix` is `inputs.nixpkgs.lib`. The new `hosts/default.nix`
  follows the same idiom internally rather than taking `lib` as a param.

## Decisions

1. **Enumeration key file is `_system.nix`, not `default.nix`.** Each host
   dir's `default.nix` remains the actual NixOS module (unchanged); the new
   `_system.nix` is metadata describing how to build that host
   (which builder, which module list).
2. **Hosts without `_system.nix` are silently skipped** (checked via
   `pathExists`, same convention as `modules/top-level/all-modules.nix`).
   This allows incremental migration — nothing breaks for hosts that
   haven't been given a `_system.nix` yet.
3. **`_system.nix` may be a function or a plain attrset.** Concretely, all
   three of these are valid:

   ```nix
   # full form: explicit builder
   { inputs, ... }:
   {
     sysBuilder = inputs.nixpkgs.lib.nixosSystem;
     modules = [
       { imports = [ ./default.nix ]; }
     ];
   }
   ```

   ```nix
   # no sysBuilder -> defaults to inputs.nixpkgs.lib.nixosSystem
   { inputs, ... }:
   {
     modules = [
       {
         imports = [
           ./default.nix
           inputs.nixos-hardware.nixosModules.some-hwcfg
         ];
       }
     ];
   }
   ```

   ```nix
   # minimal: plain attrset, no function wrapper, no sysBuilder
   {
     modules = [
       { imports = [ ./default.nix ]; }
     ];
   }
   ```

   `hosts/default.nix` detects which form it got via `builtins.isFunction`:
   if it's a function, call it with `{ inherit inputs outputs; }`; if it's
   already an attrset, use it as-is.
4. **`modules` is always a list**, mirroring what `nixosSystem` expects
   directly. No normalization (`toList`) is performed — `_system.nix`
   authors are responsible for wrapping in `[ ... ]`. It is inherited
   verbatim: `sysBuilder { inherit modules; specialArgs = {...}; }`.
5. **`sysBuilder` defaults to `inputs.nixpkgs.lib.nixosSystem`** when absent
   (`sysCfg.sysBuilder or lib.nixosSystem`).
6. **`specialArgs` is always `{ inherit inputs outputs; }`**, matching the
   existing manual `rosetta` block in `flake.nix`. `_system.nix` cannot
   override this (keeps things predictable; can be revisited later if a
   host genuinely needs different specialArgs).
7. **Output shape**: `hosts/default.nix` returns the built-configs attrset
   directly — i.e. `{ <name> = <builtConfig>; ... }` — **not** wrapped in a
   `nixosConfigurations` key. `flake.nix` does the wrapping:
   ```nix
   nixosConfigurations = import ./hosts { inherit inputs outputs; };
   ```
   (Wrapping inside `hosts/default.nix` itself would double-nest under
   `flake.nix`'s own `nixosConfigurations = ...` assignment.)
8. **`hosts/default.nix` signature is `{ inputs, outputs }:`.** `lib` is
   obtained internally via `inputs.nixpkgs.lib`, matching `flake.nix`'s own
   style. No darwin support (no input for it; out of scope).
9. **Existing hosts are not touched** by this work. No `_system.nix` is
   added to `beacon`, `bench`, `booth`, `chisel`, `fusion`, `grind`,
   `hoard`, `hydrus`, `installer`, or `rosetta`. Their `default.nix` files
   are untouched. This is deliberate — migrating real hosts to the new
   scheme is a separate, later task.
10. **`rosetta`'s manual block in `flake.nix` is removed, not migrated.**
    Since `rosetta` gets no `_system.nix` in this task, and the manual
    `nixosConfigurations.rosetta = ...` assignment would otherwise collide
    (duplicate-attribute error) with the new
    `nixosConfigurations = import ./hosts {...};` assignment, the old block
    is deleted outright. After this change, `nixosConfigurations.rosetta`
    will not exist until someone later adds `hosts/rosetta/_system.nix`.
    This is intentional and acceptable per "ignore rosetta for now,
    migration is out of scope."
11. **Validation is via three new scaffold hosts**, one per `_system.nix`
    form (see below), not via migrating a real host. This proves the
    plumbing works without risking any real machine's config and without
    scope-creeping into real-host migration.

## Non-goals

- Migrating any real host (`beacon`, `bench`, `booth`, `chisel`, `fusion`,
  `grind`, `hoard`, `hydrus`, `installer`, `rosetta`) to `_system.nix`.
- Darwin support / `darwinConfigurations`.
- Home-manager standalone configs (`homeConfigurations`).
- Changing anything under `modules/` or `modules/top-level/`.
- Making `_system.nix`'s `specialArgs` configurable per-host.

## Implementation

### 1. `hosts/default.nix`

```nix
{ inputs, outputs }:

let
  inherit (builtins)
    isFunction
    readDir
    ;

  inherit (inputs.nixpkgs) lib;

  inherit (lib)
    attrNames
    filter
    filterAttrs
    genAttrs
    pathExists
    ;

  enumerateHosts =
    { basePath }:
    let
      hostDirs = attrNames (filterAttrs (_: type: type == "directory") (readDir basePath));
      hasSystem = name: pathExists (basePath + "/${name}/_system.nix");
      hosts = filter hasSystem hostDirs;

      buildHost =
        name:
        let
          raw = import (basePath + "/${name}/_system.nix");
          sysCfg = if isFunction raw then raw { inherit inputs outputs; } else raw;
          sysBuilder = sysCfg.sysBuilder or lib.nixosSystem;
          inherit (sysCfg) modules;
        in
        sysBuilder {
          inherit modules;
          specialArgs = { inherit inputs outputs; };
        };
    in
    genAttrs hosts buildHost;
in
enumerateHosts { basePath = ./.; }
```

### 2. Three new scaffold hosts

Create these under `hosts/`, prefixed `test-` so they're obviously scaffold
and not real machines. Each needs a `_system.nix` (per its variant) and a
minimal `default.nix` that evaluates/builds cleanly under `nix flake
check` without needing real hardware config. Use the well-known
lightweight-eval trick (`boot.isContainer = true;`) so we don't need
`fileSystems`/bootloader/hardware config:

```nix
# hosts/test-*/default.nix (identical for all three, only imported
# differently per _system.nix)
{ ... }:
{
  boot.isContainer = true;
  system.stateVersion = "25.11";
}
```

**`hosts/test-full/_system.nix`** — full form, explicit `sysBuilder`:

```nix
{ inputs, ... }:
{
  sysBuilder = inputs.nixpkgs.lib.nixosSystem;
  modules = [
    { imports = [ ./default.nix ]; }
  ];
}
```

**`hosts/test-default-builder/_system.nix`** — omits `sysBuilder`:

```nix
{ inputs, ... }:
{
  modules = [
    { imports = [ ./default.nix ]; }
  ];
}
```

(Note: this variant doesn't actually need `inputs` for anything in the
scaffold — that's fine, it demonstrates the function form is accepted even
when unused, via the `...`.)

**`hosts/test-minimal/_system.nix`** — plain attrset, no function wrapper:

```nix
{
  modules = [
    { imports = [ ./default.nix ]; }
  ];
}
```

> Before wiring these into `flake.nix`, sanity-check with `nix eval
> --file` or a scratch flake that `boot.isContainer = true;` alone is
> sufficient for `config.system.build.toplevel` to evaluate without
> assertion failures under the pinned `nixos-26.05` nixpkgs. If it isn't,
> the fallback is adding a minimal `fileSystems."/" = { fsType = "tmpfs";
> device = "none"; };` to the scaffold `default.nix` (still no bootloader
> needed since `boot.isContainer` skips that requirement too — verify
> empirically).

### 3. `flake.nix`

Replace:

```nix
      nixosConfigurations.rosetta = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        modules = [
          ./hosts/rosetta
        ];
      };
```

with:

```nix
      nixosConfigurations = import ./hosts { inherit inputs outputs; };
```

Nothing else in `flake.nix` changes. `rosetta` intentionally drops out of
the flake's outputs until it's migrated (out of scope, see Decision 10).

## Definition of Done

- [ ] `hosts/default.nix` implemented exactly per the design above (or
      with justified deviations noted in the PR/commit).
- [ ] Three new scaffold hosts created: `hosts/test-full`,
      `hosts/test-default-builder`, `hosts/test-minimal`, each with its own
      `_system.nix` variant and a minimal `default.nix`.
- [ ] All existing host directories (`beacon`, `bench`, `booth`, `chisel`,
      `fusion`, `grind`, `hoard`, `hydrus`, `installer`, `rosetta`) have
      **zero** file changes — verify with `git status`/`git diff --stat`
      showing no modifications under those paths.
- [ ] `flake.nix`: `nixosConfigurations.rosetta = ...` block removed,
      replaced with `nixosConfigurations = import ./hosts { inherit inputs
      outputs; };`. No other changes to `flake.nix`.
- [ ] `nix flake check` passes with zero errors from the repo root.
- [ ] Sanity check: `nix eval .#nixosConfigurations --apply
      builtins.attrNames` (or equivalent) shows exactly `[
      "test-default-builder" "test-full" "test-minimal" ]` — confirming
      enumeration + skip-if-missing + all three `_system.nix` forms all
      work, and that no unintended host leaked in.

## Open risks / things to verify during implementation

- Whether `boot.isContainer = true;` alone is enough to satisfy NixOS
  assertions for `config.system.build.toplevel` on nixos-26.05 (needed for
  `nix flake check` to pass cheaply). Verify empirically first; adjust the
  scaffold `default.nix` if assertions fire (see fallback note above).
- `sysCfg.sysBuilder or lib.nixosSystem` relies on `or` binding to the
  attribute selection `sysCfg.sysBuilder`, not the whole expression —
  this is correct Nix precedence, but worth a quick `nix repl` sanity
  check if anything looks off.
- `pathExists` used here is `lib.pathExists` (there's no `builtins`
  reliance beyond `readDir`/`isFunction`), consistent with
  `modules/top-level/all-modules.nix`'s usage.
