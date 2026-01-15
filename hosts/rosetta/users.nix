{ ... }:
{
  users.users.bear = {
    isNormalUser = true;
    initialHashedPassword = "$y$j9T$MNX/3RpmXUWmZ7c040llV/$Cr/4LOk7Ea/pNZ6/4mIkHhb2JMcEVPTy44toW9X4fY5";
    extraGroups = [
      "wheel"
    ];
  };

  security.sudo.wheelNeedsPassword = false;
}
