inputs:

{ config, lib, pkgs, ... }:

let
  cfg = config.programs.illogical-impulse;
  pythonEnv = cfg.internal.pythonEnv;
in
{
  config = lib.mkIf cfg.enable {
    # KDE/Plasma platform theme integration (kdeglobals, Material You colors via
    # kde-material-you-colors). Using home-manager's own qt module instead of a
    # manual QT_QPA_PLATFORMTHEME sessionVariable because it also wires
    # QT_PLUGIN_PATH/QML2_IMPORT_PATH to the packages below -- without that, Qt
    # can't actually find the "kde" platform theme plugin at runtime.
    qt = {
      enable = true;
      platformTheme.name = "kde";
    };

    # Environment variables for Illogical Impulse
    home.sessionVariables = {
      QT_STYLE_OVERRIDE = "";
      ILLOGICAL_IMPULSE_DOTFILES_SOURCE = "${config.home.homeDirectory}/.config";
      SSH_AUTH_SOCK = "$XDG_RUNTIME_DIR/gcr/ssh";
    };

    # Ensure variables are available to systemd services (and Hyprland)
    systemd.user.sessionVariables = config.home.sessionVariables;

    # qt6ct is still needed by the quickshell/qs wrapper, see qt.nix
    home.packages = [ pkgs.qt6Packages.qt6ct ];

    # Enable gnome-keyring SSH agent
    services.gnome-keyring = {
      enable = true;
      components = [ "ssh" "secrets" ];
    };
  };
}
