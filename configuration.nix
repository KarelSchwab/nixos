{ config, pkgs, ... }:
let
    user = "karel";
    fullName = "Karel Schwab";
    email = "schwabk9@protonmail.com";
    hostname = "nixos";
in {
    imports = [
        ./hardware-configuration.nix
    ];

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # Nix configuration
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    # Bootloader configuration
    boot.loader = {
        grub = {
            enable = true;
            efiSupport = true;
            device = "nodev";
        };
        efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot";
        };
    };

    # Hardware configuration
    hardware = {
        # Bluetooth
        bluetooth = {
            enable = true;
            powerOnBoot = true;
        };
    };

    # Networking configuration
    networking = {
        hostName = "${hostname}";
        # Use NetworkManager to manage network connections.
        networkmanager = {
            enable = true;
        };
    };

    # Service configuration
    services = {
        xserver = {
            enable = true;
            xkb = {
                variant = "";
                layout = "za";
            };
            displayManager = {
                gdm = {
                    enable = true;
                };
            };
            windowManager.i3 = {
                enable = true;
                extraPackages = with pkgs; [
                    i3lock
                    i3status
                    i3blocks
                    dmenu
                    brightnessctl
                    playerctl
                    lxappearance
                    networkmanagerapplet
                    feh
                    pavucontrol
                    alsa-utils
                    playerctl
                    dunst
                    libnotify
                ];
            };
        };
        # Enable CUPS to print documents.
        printing = {
            enable = true;
        };
        # Bluetooth service
        blueman = {
            enable = true;
        };
        # Sound service
        pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
        };
    };

    # Set your time zone.
    time.timeZone = "Africa/Johannesburg";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_GB.UTF-8";

    # Enable sound with pipewire.
    sound.enable = true;

    security.rtkit.enable = true;

    # Enable docker
    virtualisation.docker.enable = true;

    # List packages installed in system profile
    environment.systemPackages = with pkgs; [ 
        # Utils
        wget
        xclip
        xsel
        unzip
        fd
        file
        ripgrep
        fzf
        jq
        curl
        stow

        # Programming
        nodejs_latest
        gh
        gcc
        direnv
        shellcheck

        # Applications
        alacritty
        spotify
        brave
        filezilla
        bash
    ];

    programs.git = {
        enable = true;
        config = {
            user = {
                email = "${email}";
                name = "${fullName}";
            };
        };
    };

    programs.tmux = {
        enable = true;
        clock24 = true;
        escapeTime = 0;
        keyMode = "vi";
        historyLimit = 50000;
        terminal = "screen-256color";
        plugins = [ pkgs.tmuxPlugins.yank ];
        extraConfig = ''
            set -g mouse on

            bind-key -n M-C-h resize-pane -L 5
            bind-key -n M-C-j resize-pane -D 5
            bind-key -n M-C-l resize-pane -R 5
            bind-key -n M-C-k resize-pane -U 5

            run-shell ${pkgs.tmuxPlugins.yank}/share/tmux/yank.tmux
            set -g @yank_selection 'clipboard'
            set -g @yank_selection_mouse 'clipboard'
        '';
    };

    programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        withNodeJs = true;
        withPython3 = true;
    };

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
        ohMyZsh = {
            enable = true;
            theme = "robbyrussell";
        };
    };

    programs.direnv = {
        enable = true;
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users = {
        defaultUserShell = pkgs.zsh;
        mutableUsers = true;
        users.${user} = {
            isNormalUser = true;
            description = "${fullName}";
            extraGroups = [ "networkmanager" "wheel" "docker" ];
            initialHashedPassword = "$y$j9T$C99/JcjThi8GUBUa2uqr0/$ckEMxV9Fz/OupvSsbx7sTDwLch3buTjLKoR8TjBCDF9";
            packages = with pkgs; [ 
                (pkgs.writeShellScriptBin "s" ''
                    ${pkgs.stdenv.shell} ~/.local/bin/tmux-sessionizer.sh "$@"
                '')
                (pkgs.writeScriptBin "volume" ''
                    ${pkgs.stdenv.shell} ~/.local/bin/volume.sh "$@"
                '')
            ];
        };
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "unstable"; # Did you read the comment?
}
