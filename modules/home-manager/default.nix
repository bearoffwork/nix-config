{
  # Module names are alphabetical sorted.
  presets = {
    direnv = import ./presets/direnv;
    # Opinionated git presets, including aliases.
    git = import ./presets/git;
    # common nix settings.
    nix = import ./presets/nix;
    # Simple zsh setup with basic functions,
    # including autocompletion, history search, prompt theme, zoxide (autojump), fzf integrated.
    zsh = import ./presets/zsh;
  };

  colima = import ./colima;
  awscli = import ./awscli;
}
