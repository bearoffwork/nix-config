{...}: {
  services.skhd = {
    enable = true;
    config = ''
      ctrl + cmd - return : open -a "Wezterm"
      ctrl + cmd - 3 : open -a "Google Chrome"
      ctrl + cmd - 4 : open -a "Claude"
    '';
  };
}
