{ pkgs, lib, ... }:
let
  mkXr = { name ? "", w, h, r }:
    let
      modeName = "${toString w}x${toString h}_${toString r}.00";
      scriptName = if lib.stringLength name == 0 then modeName else name;
    in
    pkgs.writeShellScriptBin "xr-${scriptName}" ''
      # xrandr doesn't parse the output correctly when you use $()
      # therefore we use eval instead
      MODELINE=$(cvt ${toString w} ${toString h} ${toString r} | tail -n 1 | cut -d " " -f2-)
      eval "xrandr --newmode $MODELINE"
      xrandr --addmode Virtual-1 ${modeName}
      xrandr -s ${modeName}
      xrandr --dpi 192
      feh-bg-fill
    '';
in
{
  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    ibm-plex
    fira-code
    fira-code-symbols
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.lightdm.enableGnomeKeyring = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  environment.systemPackages = with pkgs; [
    # For hypervisors that support auto-resizing, this script forces it.
    # I've noticed not everyone listens to the udev events so this is a hack.
    (writeShellScriptBin "xr-auto" ''
      xrandr --output Virtual-1 --auto
      feh-bg-fill
    '')
    (mkXr { name = "mbp"; w = 3024; h = 1890; r = 60; })
    (mkXr { name = "mbp-1.5"; w = 4536; h = 2835; r = 60; })
    (mkXr { name = "mbp-16"; w = 3456; h = 2160; r = 60; })
    (mkXr { name = "4k"; w = 3840; h = 2160; r = 60; })
    (mkXr { name = "5k"; w = 5120; h = 2880; r = 60; })
    (mkXr { name = "5.5k"; w = 5760; h = 3240; r = 60; })
    (mkXr { name = "6k"; w = 6400; h = 3600; r = 60; })
    (mkXr { name = "square"; w = 2880; h = 2880; r = 60; })
    (mkXr { name = "vertical-studio-display"; w = 2880; h = 5120; r = 60; })
    (mkXr { name = "things-sidebar"; w = 4296; h = 2880; r = 60; })
    (mkXr { name = "4-3"; w = 3840; h = 2880; r = 60; })
  ];

  users.users.hussein = {
    isNormalUser = true;
    home = "/home/hussein";
    extraGroups = [ "docker" "wheel" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDmbQk7DL6HY6/6zqLo1vyq56QcRxkp/QAnLW5fUqfj1LXY49LDwNLVf3Axg0xvj9Z+CUS64J3MDtFvC22sL8Sn2TyVCkjAhpG6Y0NNbIj8ZoUyOi4s+wIH5b81lS382yJKf+1kyuiLgSyiaoOVpZUvXLASSH4XQgQ/tYI4PVWrZwzDrVQ6FQJzdzClJ5H9UOzYdAWzaedET62o/OzeXmqrMzFkYefuzGQ1KhymNmNOZORbWYpxrPpr1rdvs/AaYHJVYkf+2pVMqGoNs0ZAsA/YsWlE0ucFCAXZcVhj4DUGJfKn86a3i8uXZ7PZJ7K2XGwOB0cAcz+ynay1GnVUiywddCtUGmPTiFSGIhL4N6Lwu2Qu6exBYsl1pbFXKZ3NycmCw1/LH5UkAq6qzFV7xaPjODbEsGCN2rN1qOM/8eSWaz2QOXJZjSmY/kgNmGPcjhCQ/bJ0nFiwo4e92Jj5VqPS4JGb7FbCwBKEPxCrus/+r+xomnxmjkU7NscKMSTO5QZYh22wv49mgI26UkZC9oOWEYZmYBH+pA3zIf4SORHg8oeFoBz+8dCndCkB73rh0gi/KCFMuhyH8MiT35QNIvacUmm4GHbOlZ3eWcmQlzK0jEYJEfoq+dAC+0C2PVHnWlYryjTHUcOb+QrGGwxUVcywa0Th0wcxDobFgOmMDscetw== hussein.aitlahcen@gmail.com"
    ];
  };
}
