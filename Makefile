.PHONY bootstrap-nix:
bootstrap-nix:
	./scripts/bootstrap-nix
	@echo "Run the following command:"
	@echo "source /etc/bashrc && nix-channel --add https://nixos.org/channels/nixpkgs-unstable && nix-channel --update"

.PHONY uninstall-nix-macos:
uninstall-nix-macos:
	./scripts/uninstall-nix-macos

.PHONY bootstrap-tools:
bootstrap-tools:
	./scripts/bootstrap-darwin
	./scripts/bootstrap-home-manager

.PHONY uninstall-tools:
uninstall-tools:
	./scripts/uninstall-darwin
	./scripts/uninstall-home-manager
	nix-channel --update
