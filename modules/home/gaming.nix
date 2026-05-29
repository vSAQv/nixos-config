{
  pkgs,
  config,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    # ... ваши существующие оверлеи Home Manager ...
    (final: prev: {
      openldap = prev.openldap.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];
  home.packages = with pkgs; [
    ## Utils
    gamemode
    gamescope
    winetricks
    lutris
    qbittorrent
    # inputs.nix-gaming.packages.${pkgs.stdenv.hostPlatform.system}.wine-ge

    ## Minecraft
    prismlauncher

    ## Cli games
    # _2048-in-terminal
    vitetris
    nethack

    ## Celeste
    # celeste-classic
    # celeste-classic-pm

    ## Doom
    # gzdoom
    # crispy-doom

    ## Emulation
    sameboy
    snes9x
    # cemu
    # dolphin-emu
  ];
}
