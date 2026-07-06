# /home/cif/nixos-config/modules/home/homeLab/sync.nix
{
  config,
  pkgs,
  ...
}: let
  baseDir = "/home/cif/homelab";
  configDir = "${baseDir}/config";
in {
  sops.secrets."restic_password" = {
    format = "yaml";
    sopsFile = ./secrets.yaml;
  };
  sops.secrets."restic_env" = {
    format = "yaml";
    sopsFile = ./secrets.yaml;
  };

  services.restic.backups = {
    homelab-state = {
      initialize = true;

      paths = [
        "${configDir}/audiobookshelf/absdatabase.sqlite"
        "${configDir}/bookshelf/readarr.db"
        "${configDir}/bookshelf-audio/readarr.db"
        "${configDir}/bookshelf-ebooks/readarr.db"
        "${configDir}/jellyfin/data/jellyfin.db"
        "${configDir}/jellyfin/data/library.db"
        "${configDir}/jellyseerr/db.sqlite3"
        "${configDir}/radarr/radarr.db"
        "${configDir}/sonarr/sonarr.db"
        "${configDir}/syncthing/config.xml"
        "${configDir}/filebrowser.db"
        "${configDir}/navidrome/navidrome.db"
        "${configDir}/slskd/slskd.db"
        "${configDir}/kavita/kavita.db"
        "${configDir}/jobFinder/applied.db"
      ];

      passwordFile = config.sops.secrets."restic_password".path;
      environmentFile = config.sops.secrets."restic_env".path;

      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };

      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
        "--keep-monthly 12"
      ];
    };
  };
}
