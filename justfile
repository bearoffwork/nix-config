# vi: ts=4 sw=4 sts=4 et
hm-switch target="$(whoami)@$(hostname)":
    #!/usr/bin/env bash
    home-manager switch --flake .#{{ target }}

nvim-pack-rebuild:
    #!/usr/bin/env bash
    nix build .#nvim-packs -o ~/.local/share/nvim-packs

switch host="$(hostname)":
    #!/usr/bin/env bash
    sudo darwin-rebuild switch --flake .#{{ host }}

deploy host:
    #!/usr/bin/env bash
    hostName="$(echo '{{host}}' | cut -d'@' -f2)"
    echo "Starting nixos-rebuild .#${hostName} to host: {{host}}"
    nixos-rebuild \
        --fast \
        --build-host {{host}} \
        --target-host {{host}} \
        --use-remote-sudo \
        --flake ".#${hostName}" \
        switch
