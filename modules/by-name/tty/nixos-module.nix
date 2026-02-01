{
  lib,
  pkgs,
  ...
}:
{
  console = {
    earlySetup = lib.mkDefault true;
    packages = lib.mkDefault [ pkgs.terminus_font ];
    font = lib.mkDefault "ter-u32n";
    # Modified catppuccin colors
    colors = lib.mkDefault [
      # Normal colors (ansi)
      "000000" # black
      "ed8796" # red
      "a6da95" # green
      "eed49f" # yellow
      "8aadf4" # blue
      "c6a0f6" # mauve (magenta)
      "8bd5ca" # teal (cyan)
      "b8c0e0" # white (subtext1)
      # Bright colors (brights)
      "363a4f" # bright black (surface2 - approximate)
      "ee99a0" # bright red (maroon)
      "a6da95" # bright green
      "f5a97f" # bright yellow (peach)
      "7dc4e4" # bright blue (sapphire)
      "f5bde6" # bright magenta (pink)
      "91d7e3" # bright cyan (sky)
      "cad3f5" # bright white (text)
    ];
  };
}
