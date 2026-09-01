{
  config,
  pkgs,
  lib,
  ...
}: {
  # Automate garbage collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  boot.tmp.cleanOnBoot = true;

  virtualisation.docker.autoPrune.enable = true;
  virtualisation.docker.autoPrune.dates = "weekly";

  virtualisation.podman.autoPrune.enable = true;
  virtualisation.podman.autoPrune.dates = "weekly";

  # Automatically optimize the store via hardlinks during every build
  # Note: This may increase build CPU/IO overhead slightly
  nix.settings.auto-optimise-store = true;

  # Limit systemd journal size to prevent log unbounded growth
  services.journald.extraConfig = ''
    SystemMaxUse=1G
    MaxRetentionSec=1month
  '';
}
