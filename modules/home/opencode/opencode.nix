{ pkgs, ... }:

let
  aiWorkspace = "/home/cif/Projects/ai-workspace";
  opencodeWrapper = pkgs.writeShellScriptBin "opencode" ''
    set -euo pipefail

    secret_path="/run/secrets/OPENROUTER_API_KEY"
    if [ ! -r "$secret_path" ]; then
      echo "OpenRouter secret is missing or unreadable: $secret_path" >&2
      exit 1
    fi

    export OPENROUTER_API_KEY="$(${pkgs.coreutils}/bin/cat "$secret_path")"
    export OPENCODE_CONFIG_DIR="${aiWorkspace}/config"

    exec ${pkgs.opencode}/bin/opencode "$@"
  '';
in
{
  home.packages = [
    opencodeWrapper
  ];

  systemd.user.services.opencode-web = {
    Unit = {
      Description = "OpenCode local Web UI";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${opencodeWrapper}/bin/opencode web --hostname 127.0.0.1 --port 4096";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
