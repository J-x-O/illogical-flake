inputs:

{ config, lib, pkgs, ... }:

let
  cfg = config.programs.illogical-impulse;
  pythonEnv = cfg.internal.pythonEnv;
in
{
  config = lib.mkIf cfg.enable {
    # Environment variables for Illogical Impulse
    home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "kde";  # KDE/Plasma platform theme integration (kdeglobals, Material You colors via kde-material-you-colors)
      QT_STYLE_OVERRIDE = "";
      ILLOGICAL_IMPULSE_DOTFILES_SOURCE = "${config.home.homeDirectory}/.config";
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
    };

    # Ensure variables are available to systemd services (and Hyprland)
    systemd.user.sessionVariables = config.home.sessionVariables;

    # Install qt6ct (used by the quickshell/qs wrapper, see qt.nix) and
    # plasma-integration (provides the "kde" QPA platform theme plugin)
    home.packages = [ pkgs.qt6Packages.qt6ct pkgs.kdePackages.plasma-integration ];

    # Enable gnome-keyring SSH agent
    services.gnome-keyring = {
      enable = true;
      components = [ "ssh" "secrets" ];
    };
  };
}
