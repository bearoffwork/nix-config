{pkgs ? import <nixpkgs> {}}: let
  # Use fossar overlay for PHP 7.4
  phps = import (builtins.fetchTarball {
    url = "https://github.com/fossar/nix-phps/archive/master.tar.gz";
  });

  php' = phps.packages.${pkgs.system}.php74.buildEnv {
    extensions = {
      enabled,
      all,
    }:
      enabled
      ++ (with all; [
        curl
        dom
        fileinfo
        filter
        hash
        mbstring
        opcache
        openssl
        pdo
        pdo_mysql
        session
        tokenizer
        xml
        zip
      ]);
    extraConfig = ''
      memory_limit = 256M
      upload_max_filesize = 64M
      post_max_size = 64M
    '';
  };
  nodejs' = pkgs.nodejs;
in
  pkgs.mkShell {
    buildInputs = [
      php'
      phps.packages.${pkgs.system}.php74.packages.composer
      nodejs'
      pkgs.mysql80
    ];

    shellHook = ''
      mkdir -p .bin
      ln -sf ${php'}/bin/php .bin/php
      ln -sf ${phps.packages.${pkgs.system}.php74.packages.composer}/bin/composer .bin/composer
      ln -sf ${nodejs'}/bin/node .bin/node
      ln -sf ${nodejs'}/bin/npm .bin/npm
    '';
  }
