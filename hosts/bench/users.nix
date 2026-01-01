{...}: {
  users.users = {
    bear = {
      extraGroups = ["wheel" "podman"];
    };
  };
}
