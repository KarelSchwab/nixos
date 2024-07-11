# nixos

sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos

nixos-generate-config --show-hardware-config > hardware-configuration.nix

sudo nixos-rebuild switch --flake .

sudo nixos-rebuild switch -I ./configuration.nix --upgrade
