{...}: {
  services.skhd = {
    enable = true;
    config = ''
      ctrl + cmd - return : open -a "Wezterm"
      ctrl + cmd - 1 : open -a "Line"
      ctrl + cmd - 2 : open -a "Telegram Web"
      ctrl + cmd - 3 : open -a "Google Chrome"
      ctrl + cmd - 4 : open -a "LibreChat"
    '';
  };
}
