
NIX_CONFIG := extra-experimental-features = nix-command flakes
export NIX_CONFIG

home-manager:
	nix fmt
	@if command -v home-manager >/dev/null; then \
	home-manager --flake . switch; \
	else \
	nix run home-manager -- --flake . switch; \
	fi
.PHONY: home-manager

darwin:
	nix fmt
	git add .
	@if command -v darwin-rebuild >/dev/null; then \
	darwin-rebuild --flake . switch; \
	else \
	nix run nix-darwin -- --flake . switch; \
	fi
.PHONY: darwin
