# /home/cif/nixos-config/modules/home/homeLab/docker.nix
{
  config,
  pkgs,
  ...
}: let
  baseDir = "/home/cif/homelab";
  configDir = "${baseDir}/config";
  dataDir = "${baseDir}/data";
  gamesPartitionDir = "/mnt/win_share/games";
  uploadLocation = "${dataDir}/photos/upload";

  sharedEnv = {
    PUID = "1000";
    PGID = "100";
    TZ = "Europe/Minsk";
  };
in {
  sops.secrets = {
    "litellm_env" = {
      format = "yaml";
      sopsFile = ./secrets.yaml;
    };
    "navidrome_env" = {
      format = "yaml";
      sopsFile = ./secrets.yaml;
    };
    "slskd_env" = {
      format = "yaml";
      sopsFile = ./secrets.yaml;
    };
    "gluetun_env" = {
      format = "yaml";
      sopsFile = ./secrets.yaml;
    };
    "tailscale_env" = {
      format = "yaml";
      sopsFile = ./secrets.yaml;
    };
    "immich_env" = {
      format = "yaml";
      sopsFile = ./secrets.yaml;
    };
    "gamevault_env" = {
      format = "yaml";
      sopsFile = ./secrets.yaml;
    };
    "pelican_env" = {
      format = "yaml";
      sopsFile = ./secrets.yaml;
    };
  };

  virtualisation.docker.enable = true;

  systemd.services.docker-network-homelab = {
    description = "Create homelab docker network";
    after = ["docker.service"];
    requires = ["docker.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker network create homelab || true";
    };
    wantedBy = ["multi-user.target"];
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      filebrowser = {
        image = "filebrowser/filebrowser:latest";
        ports = ["8080:80"];
        volumes = [
          "${dataDir}:/srv"
          "${configDir}/filebrowser.db:/database.db"
        ];
        extraOptions = ["--user=1000:100" "--network=homelab"];
        cmd = ["--database" "/database.db" "--root" "/srv"];
      };

      litellm = {
        image = "ghcr.io/berriai/litellm:main-latest";
        ports = ["4000:4000"];
        volumes = ["${configDir}/litellm/config.yaml:/app/config.yaml"];
        environment = {
          HTTP_PROXY = "http://gluetun:8888";
          HTTPS_PROXY = "http://gluetun:8888";
        };
        environmentFiles = [config.sops.secrets."litellm_env".path];
        dependsOn = ["gluetun"];
        cmd = ["--config" "/app/config.yaml"];
        extraOptions = ["--network=homelab"];
      };

      navidrome = {
        image = "deluan/navidrome:latest";
        ports = ["4533:4533"];
        volumes = [
          "${configDir}/navidrome:/data"
          "${dataDir}/music:/music"
        ];
        environment = {
          ND_SCANSCHEDULE = "1h";
          ND_LOGLEVEL = "info";
          ND_SESSIONTIMEOUT = "720h";
        };
        environmentFiles = [config.sops.secrets."navidrome_env".path];
        extraOptions = ["--user=1000:100" "--network=homelab"];
      };

      metube = {
        image = "alexta69/metube:latest";
        ports = ["8081:8081"];
        volumes = ["${dataDir}/music:/downloads"];
        environment = {
          UID = "1000";
          GID = "100";
          UMASK = "002";
          DOWNLOAD_DIR = "/downloads";
          AUDIO_DOWNLOAD_DIR = "/downloads";
          AUDIO_FORMAT = "mp3";
          OUTPUT_TEMPLATE = "%(title)s.%(ext)s";
        };
        extraOptions = ["--network=homelab"];
      };

      slskd = {
        image = "slskd/slskd:latest";
        ports = ["5030:5030" "50300:50300" "50300:50300/udp"];
        volumes = [
          "${configDir}/slskd:/app"
          "${dataDir}/music:/music"
        ];
        environment = {
          SLSKD_UID = "1000";
          SLSKD_GID = "100";
          UMASK = "002";
          SLSKD_HTTP_PORT = "5030";
          SLSKD_REMOTE_CONFIGURATION = "true";
          SLSKD_DOWNLOADS_DIR = "/music";
          SLSKD_SHARED_DIR = "/music";
        };
        environmentFiles = [config.sops.secrets."slskd_env".path];
        extraOptions = ["--network=homelab"];
      };

      beets = {
        image = "lscr.io/linuxserver/beets:latest";
        volumes = [
          "${configDir}/beets:/config"
          "${configDir}/beets/crontabs:/config/crontabs"
          "${dataDir}/music:/music"
        ];
        environment = sharedEnv;
        extraOptions = ["--network=homelab"];
      };

      gluetun = {
        image = "qmcgaw/gluetun:latest";
        ports = ["8888:8888/tcp"];
        extraOptions = ["--cap-add=NET_ADMIN" "--device=/dev/net/tun:/dev/net/tun" "--network=homelab"];
        environment = {
          VPN_SERVICE_PROVIDER = "protonvpn";
          VPN_TYPE = "wireguard";
          SERVER_COUNTRIES = "Netherlands";
          FREE_ONLY = "on";
          WIREGUARD_MTU = "1280";
          DNS_UPSTREAM_RESOLVER_TYPE = "plain";
          DNS_UPSTREAM_PLAIN_ADDRESSES = "1.1.1.1:53,8.8.8.8:53";
          BLOCK_MALICIOUS = "off";
          HTTPPROXY = "on";
        };
        environmentFiles = [config.sops.secrets."gluetun_env".path];
      };

      jellyfin = {
        image = "lscr.io/linuxserver/jellyfin:latest";
        ports = ["8096:8096"];
        volumes = [
          "${configDir}/jellyfin:/config"
          "${dataDir}:/data"
        ];
        environment = sharedEnv;
        extraOptions = ["--network=homelab"];
      };

      qbittorrent = {
        image = "lscr.io/linuxserver/qbittorrent:latest";
        ports = ["8090:8090" "6881:6881" "6881:6881/udp"];
        volumes = [
          "${configDir}/qbittorrent:/config"
          "${dataDir}:/data"
        ];
        environment = sharedEnv // {WEBUI_PORT = "8090";};
        extraOptions = ["--network=homelab"];
      };

      radarr = {
        image = "lscr.io/linuxserver/radarr:latest";
        ports = ["7878:7878"];
        volumes = [
          "${configDir}/radarr:/config"
          "${dataDir}:/data"
        ];
        environment = sharedEnv;
        extraOptions = ["--network=homelab"];
      };

      sonarr = {
        image = "lscr.io/linuxserver/sonarr:latest";
        ports = ["8989:8989"];
        volumes = [
          "${configDir}/sonarr:/config"
          "${dataDir}:/data"
        ];
        environment = sharedEnv;
        extraOptions = ["--network=homelab"];
      };

      spoofdpi = {
        image = "ghcr.io/unmedius/spoof-dpi:latest";
        ports = ["8889:8080"];
        extraOptions = ["--network=homelab"];
      };

      jackett = {
        image = "lscr.io/linuxserver/jackett:latest";
        ports = ["9117:9117"];
        volumes = ["${configDir}/jackett:/config"];
        environment = sharedEnv;
        extraOptions = ["--network=homelab"];
      };

      seerr = {
        image = "ghcr.io/seerr-team/seerr:latest";
        ports = ["5055:5055"];
        volumes = ["${configDir}/jellyseerr:/app/config"];
        environment = {TZ = sharedEnv.TZ;};
        extraOptions = ["--init" "--network=homelab"];
      };

      bookshelf-ebooks = {
        image = "ghcr.io/pennydreadful/bookshelf:hardcover";
        ports = ["8787:8787"];
        volumes = [
          "${configDir}/bookshelf-ebooks:/config"
          "${dataDir}:/data"
        ];
        environment = sharedEnv;
        extraOptions = ["--network=homelab"];
      };

      bookshelf-audio = {
        image = "ghcr.io/pennydreadful/bookshelf:hardcover";
        ports = ["8788:8787"];
        volumes = [
          "${configDir}/bookshelf-audio:/config"
          "${dataDir}:/data"
        ];
        environment = sharedEnv;
        extraOptions = ["--network=homelab"];
      };

      audiobookshelf = {
        image = "ghcr.io/advplyr/audiobookshelf:latest";
        ports = ["13378:80"];
        volumes = [
          "${configDir}/audiobookshelf:/config"
          "${configDir}/audiobookshelf/metadata:/metadata"
          "${dataDir}/media/audiobooks:/audiobooks"
          "${dataDir}/media/books:/ebooks"
        ];
        environment = sharedEnv;
        extraOptions = ["--network=homelab"];
      };

      kavita = {
        image = "lscr.io/linuxserver/kavita:latest";
        ports = ["5000:5000"];
        volumes = [
          "${configDir}/kavita:/config"
          "${dataDir}/media/manga:/manga"
          "${dataDir}/media/books:/books"
        ];
        environment = sharedEnv;
        extraOptions = ["--network=homelab"];
      };

      suwayomi = {
        image = "ghcr.io/suwayomi/tachidesk:latest";
        ports = ["4567:4567"];
        volumes = [
          "${configDir}/suwayomi:/home/suwayomi/.local/share/Tachidesk"
          "${dataDir}/media/manga:/home/suwayomi/.local/share/Tachidesk/downloads"
        ];
        environment = sharedEnv // {SOCKS_PROXY_ENABLED = "false";};
        extraOptions = ["--user=1000:100" "--network=homelab"];
      };

      flaresolverr = {
        image = "ghcr.io/flaresolverr/flaresolverr:latest";
        ports = ["8191:8191"];
        environment = {
          LOG_LEVEL = "info";
          TZ = sharedEnv.TZ;
        };
        extraOptions = ["--network=homelab"];
      };

      tailscale-proxy-exit = {
        image = "alpine:latest";
        volumes = [
          "${configDir}/tailscale-proxy-exit:/var/lib/tailscale"
          "${configDir}/tailscale-proxy-exit/proxy-entrypoint.sh:/entrypoint.sh:ro"
        ];
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
          "--sysctl=net.ipv4.ip_forward=1"
          "--sysctl=net.ipv6.conf.all.forwarding=1"
          "--device=/dev/net/tun:/dev/net/tun"
          "--network=homelab"
        ];
        cmd = ["/entrypoint.sh"];
        environmentFiles = [config.sops.secrets."tailscale_env".path];
      };

      syncthing = {
        image = "lscr.io/linuxserver/syncthing:latest";
        ports = ["8384:8384" "22000:22000/tcp" "22000:22000/udp" "21027:21027/udp"];
        volumes = [
          "${configDir}/syncthing:/config"
          "${dataDir}/saves:/saves"
        ];
        environment = sharedEnv;
        extraOptions = ["--network=homelab"];
      };
    };
  };

  virtualisation.arion = {
    backend = "docker";
    projects = {
      immich = {
        settings = {
          project.name = "immich";
          services = {
            immich-server = {
              service = {
                image = "ghcr.io/immich-app/immich-server:release";
                volumes = [
                  "${uploadLocation}:/usr/src/app/upload"
                  "/etc/localtime:/etc/localtime:ro"
                ];
                ports = ["2283:2283"];
                depends_on = ["redis" "database"];
                env_file = [config.sops.secrets."immich_env".path];
                restart = "unless-stopped";
              };
            };
            immich-machine-learning = {
              service = {
                image = "ghcr.io/immich-app/immich-machine-learning:release";
                volumes = ["${configDir}/immich-cache:/cache"];
                env_file = [config.sops.secrets."immich_env".path];
                restart = "unless-stopped";
              };
            };
            redis.service = {
              image = "redis:6.2-alpine";
              restart = "unless-stopped";
            };
            database = {
              service = {
                image = "tensorchord/pgvecto-rs:pg14-v0.2.0";
                volumes = ["${configDir}/immich-db:/var/lib/postgresql/data"];
                env_file = [config.sops.secrets."immich_env".path];
                command = ["postgres" "-c" "shared_preload_libraries=vectors.so" "-c" "search_path=\"$$user\", public, vectors" "-c" "logging_collector=on" "-c" "max_wal_size=2GB" "-c" "shared_buffers=512MB" "-c" "wal_compression=on"];
                restart = "unless-stopped";
              };
            };
          };
        };
      };

      gamevault = {
        settings = {
          project.name = "gamevault";
          services = {
            gamevault-backend = {
              service = {
                image = "phalcode/gamevault-backend:latest";
                ports = ["8082:8080"];
                volumes = [
                  "${configDir}/gamevault:/config"
                  "${gamesPartitionDir}:/games"
                ];
                depends_on = ["gamevault-db"];
                env_file = [config.sops.secrets."gamevault_env".path];
                restart = "unless-stopped";
              };
            };
            gamevault-db = {
              service = {
                image = "postgres:15-alpine";
                volumes = ["${configDir}/gamevault-db:/var/lib/postgresql/data"];
                env_file = [config.sops.secrets."gamevault_env".path];
                restart = "unless-stopped";
              };
            };
          };
        };
      };

      pelican = {
        settings = {
          project.name = "pelican";
          services = {
            pelican-panel = {
              service = {
                image = "ghcr.io/pelican-dev/panel:latest";
                ports = ["8084:8084"];
                volumes = ["${configDir}/pelican:/app/storage"];
                depends_on = ["pelican-db" "redis"];
                env_file = [config.sops.secrets."pelican_env".path];
                environment = {APP_TIMEZONE = sharedEnv.TZ;};
                restart = "unless-stopped";
              };
            };
            pelican-db = {
              service = {
                image = "mariadb:10.6";
                volumes = ["${configDir}/pelican-db:/var/lib/mysql"];
                env_file = [config.sops.secrets."pelican_env".path];
                restart = "unless-stopped";
              };
            };
            pelican-wings = {
              service = {
                image = "ghcr.io/pelican-dev/wings:latest";
                ports = ["8085:8080" "2022:2022"];
                volumes = [
                  "/var/run/docker.sock:/var/run/docker.sock"
                  "/var/lib/docker/containers:/var/lib/docker/containers"
                  "${configDir}/pelican-wings/config:/etc/pelican"
                  "${dataDir}/pelican-servers:/var/lib/pelican/volumes"
                  "/tmp/pelican:/tmp/pelican"
                ];
                environment = {TZ = sharedEnv.TZ;};
                restart = "unless-stopped";
              };
            };
            redis.service = {
              image = "redis:6.2-alpine";
              restart = "unless-stopped";
            };
          };
        };
      };
    };
  };
}
