# Nixos

Welcome to my Nixos configuration.

# My setup

I try to keep my configuration minimal and as simple as possible. 
Feel free to copy and change it to fit your needs. 

IMPORTANT: Update the information (user, fullName, email, hostname) in the 
`configuration.nix` file before running the installation.

Main components:

- **OS**: [Nixos](https://nixos.org)
- **Window Manager**: [i3](https://i3wm.org)
- **Terminal**: [Alacritty](https://github.com/alacritty/alacritty)
- **Shell**: [Zsh](https://www.zsh.org)
- **Tmux**: [Tmux](https://github.com/tmux/tmux/wiki)
- **Editor**: [Neovim](https://neovim.io)
- **Browser**: [Brave](https://brave.com)
- **Launcher**: [Rofi](https://github.com/davatorium/rofi)
- **Spotify**: [Spotify](https://www.spotify.com)

## Theme

[Gruvbox](https://github.com/morhetz/gruvbox)

# Installation

```bash
git clone https://github.com/KarelSchwab/nixos && cd nixos
```

```bash
# I like to use the unstable channel
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
sudo nix-channel --update
```

```bash
# This step is important to ensure that your system boots :)
nixos-generate-config --show-hardware-config > hardware-configuration.nix
```

```bash
sudo nixos-rebuild switch --flake .#nixos --upgrade
```

# Dotfiles

Dotfiles are managed by [stow](https://www.gnu.org/software/stow/manual/stow.html)
and can be installed by running the following command:

```bash
stow -t $HOME --dotfiles dotfiles
```

## Dotfiles structure

```text
dotfiles
├── dot-local
│   ├── Scripts and other executables
├── dot-config
│   ├── Configuration files
```

