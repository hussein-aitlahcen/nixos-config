{ config, pkgs, ... }:

{
  home-manager.users.cor = {
    programs.git = {
      enable = true;
      userName = "cor";
      userEmail = "cor@pruijs.dev";
    };
    programs.rofi = {
      enable = true;
      terminal = "${pkgs.kitty}/bin/kitty";
      theme = "/etc/nixos/rofi/theme.rafi";
    };
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
    };
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        mpdSupport = true;
        pulseSupport = true;
      };
      config = ./polybar/polybar.ini;
      script = ''
        polybar main &
      '';
    };

    xresources.properties = {
      "Xft.dpi" = 96;
    };
  };

}
