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

    # Enable QT framework
    qt.enable = true;
    qt.style = "adwaita-dark";

    # Enable XDG icons
    xdg.icons.enable = true;

    environment.systemPackages = with pkgs;
    [
      glxinfo
    ];

    hardware.opengl.extraPackages = [ pkgs.mesa.drivers ];
  };
}
