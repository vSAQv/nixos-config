# /home/cif/nixos-config/modules/home/homeLab/declaration.nix
{
  config,
  pkgs,
  ...
}: let
  baseDir = "/home/cif/homelab";
  configDir = "${baseDir}/config";
  dataDir = "${baseDir}/data";
in {
  systemd.tmpfiles.rules = [
    # --- Core Directories ---
    "d ${baseDir} 0755 cif users - -"
    "d ${configDir} 0755 cif users - -"
    "d ${dataDir} 0755 cif users - -"

    # --- Media Library Hierarchy ---
    "d ${dataDir}/media 0755 cif users - -"
    "d ${dataDir}/media/animated_movies 0755 cif users - -"
    "d ${dataDir}/media/anime 0755 cif users - -"
    "d ${dataDir}/media/audiobooks 0755 cif users - -"
    "d ${dataDir}/media/books 0755 cif users - -"
    "d ${dataDir}/media/books/epub 0755 cif users - -"
    "d ${dataDir}/media/books/pdf 0755 cif users - -"
    "d ${dataDir}/media/cartoons 0755 cif users - -"
    "d ${dataDir}/media/manga 0755 cif users - -"
    "d ${dataDir}/media/manga/mangas 0755 cif users - -"
    "d ${dataDir}/media/manga/thumbnails 0755 cif users - -"
    "d ${dataDir}/media/movies 0755 cif users - -"
    "d ${dataDir}/media/tv 0755 cif users - -"
    "d ${dataDir}/media/wikipedia 0755 cif users - -"
    "d ${dataDir}/music 0755 cif users - -"

    # --- Immich Storage Hierarchy ---
    "d ${dataDir}/photos 0755 cif users - -"
    "d ${dataDir}/photos/upload 0755 cif users - -"
    "d ${dataDir}/photos/backups 0755 cif users - -"
    "d ${dataDir}/photos/encoded-video 0755 cif users - -"
    "d ${dataDir}/photos/library 0755 cif users - -"
    "d ${dataDir}/photos/profile 0755 cif users - -"
    "d ${dataDir}/photos/thumbs 0755 cif users - -"

    # --- Application Data Mounts ---
    "d ${dataDir}/saves 0755 cif users - -"
    "d ${dataDir}/torrents 0755 cif users - -"
    "d ${dataDir}/pelican-servers 0755 cif users - -"
    "d ${dataDir}/wikipedia 0755 cif users - -"

    # --- Configuration Directories ---
    "d ${configDir}/audiobookshelf 0755 cif users - -"
    "d ${configDir}/audiobookshelf/metadata 0755 cif users - -"
    "d ${configDir}/beets 0755 cif users - -"
    "d ${configDir}/beets/crontabs 0755 cif users - -"
    "d ${configDir}/bookshelf 0755 cif users - -"
    "d ${configDir}/bookshelf-audio 0755 cif users - -"
    "d ${configDir}/bookshelf-ebooks 0755 cif users - -"
    "d ${configDir}/filebrowser 0755 cif users - -"
    "d ${configDir}/gamevault 0755 cif users - -"
    "d ${configDir}/immich-cache 0755 cif users - -"
    "d ${configDir}/jackett 0755 cif users - -"
    "d ${configDir}/jellyfin 0755 cif users - -"
    "d ${configDir}/jellyseerr 0755 cif users - -"
    "d ${configDir}/kavita 0755 cif users - -"
    "d ${configDir}/litellm 0755 cif users - -"
    "d ${configDir}/navidrome 0755 cif users - -"
    "d ${configDir}/pelican 0755 cif users - -"
    "d ${configDir}/pelican-wings 0755 cif users - -"
    "d ${configDir}/pelican-wings/config 0755 cif users - -"
    "d ${configDir}/qbittorrent 0755 cif users - -"
    "d ${configDir}/radarr 0755 cif users - -"
    "d ${configDir}/slskd 0755 cif users - -"
    "d ${configDir}/sonarr 0755 cif users - -"
    "d ${configDir}/suwayomi 0755 cif users - -"
    "d ${configDir}/syncthing 0755 cif users - -"
    "d ${configDir}/tailscale-proxy-exit 0755 cif users - -"
    "d ${configDir}/job-finder 0755 cif users - -"
    "d ${configDir}/job-finder/resumes 0755 cif users - -"

    # --- Read-Only Symlinks (L+) ---
    # These files become immutable. Modifying them at runtime will fail.
    # "L+ ${configDir}/litellm/config.yaml - - - - ${./configs/litellm-config.yaml}"
    # "L+ ${configDir}/tailscale-proxy-exit/proxy-entrypoint.sh - - - - ${./configs/proxy-entrypoint.sh}"
    # "L+ ${configDir}/beets/beets.sh - - - - ${./configs/beets.sh}"

    # --- Writable Templates (C) ---
    # These files are copied only if they do not exist, allowing runtime modifications.
    # "C ${configDir}/qbittorrent/qBittorrent.conf - - - - ${./configs/qBittorrent.conf}"
    # "C ${configDir}/sonarr/config.xml - - - - ${./configs/sonarr-config.xml}"
    # "C ${configDir}/radarr/config.xml - - - - ${./configs/radarr-config.xml}"
    # "C ${configDir}/beets/config.yaml - - - - ${./configs/beets-config.yaml}"
  ];
}
