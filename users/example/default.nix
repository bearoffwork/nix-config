# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  config,
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    outputs.homeManagerModules.presets.direnv
    outputs.homeManagerModules.presets.nix
    outputs.homeManagerModules.presets.git
    outputs.homeManagerModules.presets.zsh

    # nixvim
    # outputs.homeManagerModules.nixvim

    # You can also split up your configuration and import pieces of it here:
    ./git.nix
  ];

  presets = {
    # see modules/home-manager/presets/git/aliases.nix for aliases peset definiiton.
    # git.aliases.enable = true;

    # Make shell prompt at bottom
    zsh.promptAtBottom = true;

    # We're using powerlevel10k as default prompt, it has friendly config wizard better for beginners.
    # This is the default so it can be omitted.
    # zsh.prompt = "powerlevel10k";

    # Uncomment following line if want to place your .p10k.zsh elsewhere.
    # zsh.powerlevel10k.configFile = "${config.xdg.configHome}/zsh/p10k.zsh";
    # When using XDG defaults above is equals to following
    # zsh.powerlevel10k.configFile = "~/.config/zsh/.p10k.zsh";

    # Uncomment folloing line, if you want to use starship.
    # zsh.prompt = "starship";

    # Here's a expremental trainsint prompt for zsh, disabled by default.
    # You can override transint style with profile, for example:
    # # ~/.config/starship.toml
    # [profiles]
    # transient = "$time$character"
    # zsh.starship.transientPrompt = true;
  };

  # Define your packages here.
  home.packages = with pkgs; [
    gnumake # Makefile
    git
    gh

    # jq # Command-line JSON processor
    # gnused # Replace BSD sed with gnu one

    # rusty coreutils
    # bat # cat
    # fd # find
    # ripgrep # grep
    # just # Makefile alternatives, support python, php, etc.
  ];

  home.shellAliases = {
    # hm = "home-manager";
    # g = "git";
    # vi = "nvim";
  };

  # home-manager can manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
