{ inputs, pkgs, ... }:
{
  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  environment.systemPackages = with pkgs; [
    # xwaylandvideobridge
    (symlinkJoin {
      name = "sonixd-wayland";
      paths = [ sonixd ];
      buildInputs = [ makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/sonixd \
          --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland --disable-gpu"
      '';
    })
  ];
}
