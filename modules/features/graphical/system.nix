{ config, pkgs, lib, inputs, ...}:
  with lib;
{
  imports = [
    ./dm/system.nix

    ./gnome/system.nix
  ];

  config = mkIf (
    (builtins.elem "graphical" config.sanix.features) ||
    (builtins.any (e: (builtins.match "^graphical-.*" e) != null) config.sanix.features)
  ) {
    # Enable the X11 windowing system.
    services.xserver = {
      enable = true;

      layout = "us";
      xkbOptions = "eurosign:e,caps:escape";
      libinput = {
        enable = true;

        # disabling mouse acceleration
        mouse = {
          accelProfile = "flat";
        };

        # disabling touchpad acceleration
        touchpad = {
          accelProfile = "flat";
          tapping = true;
        };
      };
    };

    # Enable interfacing X11 with Wayland
    programs.xwayland.enable = true;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QT_QPA_PLATFORM = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };

    # Enable QT framework
    qt.enable = true;
    qt.style = "adwaita-dark";

    # Enable XDG icons
    xdg.icons.enable = true;
  };
}
