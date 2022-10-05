inputs: { config, lib, pkgs, ... }:
let
  discord-chromium = pkgs.makeDesktopItem rec {
    name = "Discord";
    desktopName = "Discord";
    genericName = "All-in-one cross-platform voice and text chat for gamers";
    exec = "${pkgs.chromium}/bin/chromium --app=\"https://discord.com/channels/@me\"";
    icon = "discord";
    type = "Application";
    terminal = false;
  };
  slack-chromium = pkgs.makeDesktopItem rec {
    name = "Slack";
    desktopName = "Slack";
    genericName = "One platform for your team and your work";
    exec = "${pkgs.chromium}/bin/chromium --app=\"https://app.slack.com/client/T021F0XJ8BE/C02MSA16DCP\"";
    icon = "slack";
    type = "Application";
    terminal = false;
  };
  clickup-chromium = pkgs.makeDesktopItem rec {
    name = "ClickUp";
    desktopName = "ClickUp";
    genericName = "One app to replace them all";
    exec = "${pkgs.chromium}/bin/chromium --app=\"https://app.clickup.com/\"";
    icon = "clickup";
    type = "Application";
    terminal = false;
  };
in
{
  xdg.enable = true;

  #---------------------------------------------------------------------
  # Packages
  #---------------------------------------------------------------------

  # Packages I always want installed. Most packages I install using
  # per-project flakes sourced with direnv and nix-shell, so this is
  # not a huge list.
  home.packages = with pkgs; [
    bat # cat replacement
    exa # ls replacement
    gping # ping with graph
    fd
    firefox
    fzf
    htop
    jq
    ripgrep
    ranger
    tree
    watch
    kitty
    openssh
    feh
    zip
    rnix-lsp
    curl
    delta
    pamixer
    wget
    git
    scrot
    git-lfs
    coreutils-full
    binutils
    gnome3.gnome-control-center
    xclip
    gtkmm3 # needed for the vmware user tools clipboard
    neofetch
    nixfmt
    pinentry
    pinentry-curses
    pick-colour-picker
    vscode
    bottom
    discord-chromium
    tdesktop
    lazygit
    element-desktop
    slack-chromium
    clickup-chromium
    (writeShellScriptBin "feh-bg-fill" ''
      feh --bg-fill /home/cor/.background-image
    '')
  ];


  home.file.".background-image".source = ../../wallpapers/nix-space.jpg;
  home.file."Screenshots/.keep".source = ./.keep;
  # home.file.".config/helix/config.toml".source = ./helix.toml;
  # home.file.".config/helix/languages.toml".source = ./languages.toml;

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  # home.sessionVariables = {
  #   LANG = "en_US.UTF-8";
  #   LC_CTYPE = "en_US.UTF-8";
  #   LC_ALL = "en_US.UTF-8";
  #   EDITOR = "nvim";
  #   PAGER = "less -FirSwX";
  #   MANPAGER = "sh -c 'col -bx | ${pkgs.bat}/bin/bat -l man -p'";
  # };

  # home.file.".gdbinit".source = ./gdbinit;
  # home.file.".inputrc".source = ./inputrc;

  # xdg.configFile."i3/config".text = builtins.readFile ./i3;
  xdg.configFile."rofi/config.rasi".text = builtins.readFile ./rofi;
  # xdg.configFile."devtty/config".text = builtins.readFile ./devtty;

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  # programs.bash = {
  #   enable = true;
  #   shellOptions = [];
  #   historyControl = [ "ignoredups" "ignorespace" ];
  #   # initExtra = builtins.readFile ./bashrc;
  # };

  # programs.direnv = {
  #   enable = true;

  # config = {
  #   whitelist = {
  #     prefix= [
  #       "$HOME/code/go/src/github.com/hashicorp"
  #       "$HOME/code/go/src/github.com/mitchellh"
  #     ];

  #     exact = ["$HOME/.envrc"];
  #   };
  # };
  # };

  programs.git = {
    enable = true;
    userName = "hussein";
    userEmail = "hussein.aitlahcen@gmail.com";
    lfs.enable = true;
    signing = {
      signByDefault = true;
      key = "3B7CA836ACA61E646A0BDC80FC5CB669F3A22DE4";
    };
    extraConfig = {
      # branch.autosetuprebase = "always";
      color.ui = true;
      # core.askPass = ""; # needs to be empty to use terminal for ask pass
      # credential.helper = "store"; # want to make this more secure
      github.user = "hussein-aitlahcen";
      # push.default = "tracking";
      # init.defaultBranch = "main";
    };
  };


  programs.alacritty = {
    enable = true;
    settings = {
      scrolling = {
        history = 100000;
        multiplier = 1;
        faux_multiplier = 1;
        auto_scroll = false;
      };
    };
  };

  programs.chromium = {
    enable = true;
    package = pkgs.chromium;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "mopnmbcafieddcagagdcbnhejhlodfdd" # Polkadot js
    ];
  };

  programs.zsh = {
    enable = true;
    prezto = {
      enable = true;
      pmodules = [
        "git"
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "spectrum"
        "utility"
        "completion"
        "syntax-highlighting"
        "history-substring-search"
        "prompt"
      ];
    };
    shellAliases = {
      fzf-nix = "nix-env -qa | fzf";
      icat = "kitty +kitten icat";
      lg = "lazygit";
      pbcopy = "xclip -selection c"; # macOS' pbcopy equivalent
      ls = "exa";
    };
    initExtra = ''
      if [ -n "''${commands[fzf-share]}" ]; then
        source "''$(fzf-share)/key-bindings.zsh"
        source "''$(fzf-share)/completion.zsh"
      fi
    '';
  };

  programs.gpg = {
    enable = true;
    settings = {
      default-key = "06A6337C2BDD1365883C0668DB347466107E589F";
    };
  };

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.kitty}/bin/kitty";
    theme = ./rofi;
    plugins = [ pkgs.rofi-emoji ];
  };

  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 1000000;
      enable_audio_bell = false;
      update_check_interval = 0;
      wheel_scroll_multiplier = 1;
      wheel_scroll_min_lines = 1;
      touch_scroll_multiplier = 1;
    };
    keybindings = {
      "kitty_mod+n" = "new_os_window_with_cwd";
    };
    theme = "One Half";
  };

  xsession.windowManager.awesome = {
    enable = true;
  };

  home.file.".config/awesome".source = ../../awesome;
  home.file.".config/ranger/rc.conf".source = ./ranger.conf;

  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "gnome3";
    enableSshSupport = true;

    # cache the keys forever so we don't get asked for a password
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };
  xresources.properties = {
    "Xft.dpi" = 192;
  };
}
