# nix-config for both darwin and nixos (WIP)

## Darwin (MacOS)

### 1. Install nix
https://nixos.org/download/

Fist, install the nix
```shell
sh <(curl -L https://nixos.org/nix/install)
```

To create system users in a different range that the Nix daemon uses to run builds, use following
```shell
NIX_FIRST_BUILD_UID={id} sh <(curl -L https://nixos.org/nix/install)

# for example, uids [10001..10032]
# NIX_FIRST_BUILD_UID=10001 sh <(curl -L https://nixos.org/nix/install)
```

### Home manager

#### Step 1: Update nix.conf

Assuming you're the admin of the device, add yourself to the trusted users list.
```ini
trusted-users = @admin
```

Enable experimental features required for this project.
 - `nix-command` allows using the `nix` commands like `nix shell`, `nix profile`, `nix run`, etc.
 - `flakes` enables support for Nix Flakes.

```ini
extra-experimental-features = nix-command flakes
```

Opinionated: follow XDG Base Directory to keep home directory clean.
```ini
use-xdg-base-directories = true
```

#### Complete nix.conf:
Your nix.conf should looks like this.
```ini

build-users-group = nixbld
trusted-users = @admin
extra-experimental-features = nix-command flakes
use-xdg-base-directories = true
```

Then kill nix-daemon to apply new settings.
```shell
sudo killall nix-daemon
```

Assuming no tools are installed yet, use nix shell to create a shell environment with the tools needed for setting up:
```shell
nix shell nixpkgs#gnumake nixpkgs#gh nixpkgs#git
```

login to github, and clone the nix-config
```shell
gh auth login
gh repo clone euimoney/nix-config ~/.config/home-manager
cd ~/.config/home-manager
```

check your current hostname
```shell
scutil --get LocalHostName
```

If you wish to change your hostname, you can do so with the following command.
This is equivalent to changing it in macOS settings via: `Preferences.app > General > Sharing > "Local hostname" at bottom > Edit`
```shell
scutil --set LocalHostName "Your_New_Hostname"
```


### FAQ


#### SSL error
```
warning: error: unable to download 'https://channels.nixos.org/flake-registry.json': Problem with the SSL CA cert (path? access rights?) (77); using cached version
warning: error: unable to download 'https://api.github.com/repos/NixOS/nixpkgs/commits/nixpkgs-unstable': Problem with the SSL CA cert (path? access rights?) (77); using cached version
warning: error: unable to download 'https://api.github.com/repos/NixOS/nixpkgs/commits/nixpkgs-unstable': Problem with the SSL CA cert (path? access rights?) (77); using cached version
warning: error: unable to download 'https://api.github.com/repos/NixOS/nixpkgs/commits/nixpkgs-unstable': Problem with the SSL CA cert (path? access rights?) (77); using cached version
```

https://github.com/NixOS/nix/issues/2899#issuecomment-1669501326
```shell
sudo ln -s /nix/var/nix/profiles/default/etc/ssl/certs/ca-bundle.crt /etc/ssl/certs/ca-certificates.crt
```