{pkgs, ...}: {
  home.packages = with pkgs; [
    sops
    age
  ];

  home.shellAliases = {
    senve = "sops edit --input-type dotenv --output-type dotenv";
    senvr = "sops -r --input-type dotenv --output-type dotenv";
  };
}
