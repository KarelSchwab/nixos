{ config, pkgs, ... }:
let
    user = "karel";
    fullName = "Karel Schwab";
    email = "35557567+KarelSchwab@users.noreply.github.com";
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
                    rofi
                    base16-schemes
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
        python311Full
        nodejs_latest
        gh
        gcc
        direnv
        shellcheck
        acpi
        sysstat

        # Applications
        alacritty
        spotify
        brave
        filezilla
        bash
        vlc
        gimp

        cinnamon.xreader
        nautilus
        gnome-calculator
        eog
    ];

    fonts = {
        fontconfig = {
            defaultFonts ={
                serif = [
                    "Cascadia Code"
                ];
                sansSerif = [
                    "Cascadia Code"
                ];
                monospace = [
                    "Cascadia Code"
                ];
            };
        };
        packages = with pkgs; [
            pkgs.cascadia-code
        ];
    };

    programs.git = {
        enable = true;
        config = {
            user = {
                email = "${email}";
                name = "${fullName}";
            };
            push = {
                autoSetupRemote = true;
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

            ## COLORSCHEME: gruvbox dark (medium)
            set-option -g status "on"

            # default statusbar color
            set-option -g status-style bg=colour237,fg=colour223 # bg=bg1, fg=fg1

            # default window title colors
            set-window-option -g window-status-style bg=colour214,fg=colour237 # bg=yellow, fg=bg1

            # default window with an activity alert
            set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

            # active window title colors
            set-window-option -g window-status-current-style bg=red,fg=colour237 # fg=bg1

            # pane border
            set-option -g pane-active-border-style fg=colour250 #fg2
            set-option -g pane-border-style fg=colour237 #bg1

            # message infos
            set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1
            
            # writing commands inactive
            set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1
            
            # pane number display
            set-option -g display-panes-active-colour colour250 #fg2
            set-option -g display-panes-colour colour237 #bg1
            
            # clock
            set-window-option -g clock-mode-colour colour109 #blue
            
            # bell
            set-window-option -g window-status-bell-style bg=colour167,fg=colour235 # bg=red, fg=bg
            
            ## Theme settings mixed with colors (unfortunately, but there is no cleaner way)
            set-option -g status-justify "left"
            set-option -g status-left-style none
            set-option -g status-left-length "80"
            set-option -g status-right-style none
            set-option -g status-right-length "80"
            set-window-option -g window-status-separator ""
            
            set-option -g status-left "#[bg=colour241,fg=colour248] #S #[bg=colour237,fg=colour241,nobold,noitalics,nounderscore]"
            set-option -g status-right "#[bg=colour237,fg=colour239 nobold, nounderscore, noitalics]#[bg=colour239,fg=colour246] %Y-%m-%d  %H:%M #[bg=colour239,fg=colour248,nobold,noitalics,nounderscore]#[bg=colour248,fg=colour237] #h "
            
            set-window-option -g window-status-current-format "#[bg=colour214,fg=colour237,nobold,noitalics,nounderscore]#[bg=colour214,fg=colour239] #I #[bg=colour214,fg=colour239,bold] #W#{?window_zoomed_flag,*Z,} #[bg=colour237,fg=colour214,nobold,noitalics,nounderscore]"
            set-window-option -g window-status-format "#[bg=colour239,fg=colour237,noitalics]#[bg=colour239,fg=colour223] #I #[bg=colour239,fg=colour223] #W #[bg=colour237,fg=colour239,noitalics]"
            
            # vim: set ft=tmux tw=0 nowrap:
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

    stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
        image = ./wallpapers/wallpaper.png;
        targets.feh.enable = true;
        polarity = "dark";
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "unstable"; # Did you read the comment?
}
