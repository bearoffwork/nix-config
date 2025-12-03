{pkgs, ...}: let
  php' = pkgs.php84.buildEnv {
    extensions = {
      enabled,
      all,
    }:
      enabled;
  };
  nodejs' = pkgs.nodejs_22;
in
  pkgs.mkShell {
    buildInputs = [
      php'
      php'.packages.composer
      nodejs'
    ];

    shellHook = ''
      mkdir -p .bin
      ln -sf ${php'}/bin/php .bin/php
      ln -sf ${php'.packages.composer}/bin/composer .bin/composer
      ln -sf ${nodejs'}/bin/node .bin/node
      ln -sf ${nodejs'}/bin/npm .bin/npm
    '';
  }
