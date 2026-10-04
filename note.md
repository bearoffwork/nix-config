
init

```bash

mkdir -p $HOME/src/p/nix-config

git clone https://github.com/bearoffwork/nix-config $HOME/src/p/nix-config

# hm init
nix run github:nix-community/home-manager/master -- switch --flake .

# sync purchased fonts
rsync -az ~/Library/Fonts/ComicCode* fusion:.local/share/fonts/
```

```
nix run github:nix-community/home-manager/master#home-manager -- \
    switch \
    --flake github:bearoffwork#bear@grind
```
