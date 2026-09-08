{ pkgs, ... }:

let
  aiWorkspace = "/home/cif/Projects/ai-workspace";
  workspaceWrapper = pkgs.writeShellScriptBin "workspace" ''
    set -euo pipefail
    export PYTHONPATH="${aiWorkspace}''${PYTHONPATH:+:''${PYTHONPATH}}"
    exec ${pkgs.python3}/bin/python3 -m ai_workspace "$@"
  '';
  workspaceValidateWrapper = pkgs.writeShellScriptBin "workspace-validate" ''
    exec ${workspaceWrapper}/bin/workspace validate "$@"
  '';
  workspaceTestWrapper = pkgs.writeShellScriptBin "workspace-test" ''
    set -euo pipefail
    export PYTHONPATH="${aiWorkspace}''${PYTHONPATH:+:''${PYTHONPATH}}"
    exec ${pkgs.python3}/bin/python3 -m unittest discover -s ${aiWorkspace}/tests -v "$@"
  '';
  opencodeWrapper = pkgs.writeShellScriptBin "opencode" ''
    set -euo pipefail

    secret_path="/run/secrets/OPENROUTER_API_KEY"
    if [ ! -r "$secret_path" ]; then
      echo "OpenRouter secret is missing or unreadable: $secret_path" >&2
      exit 1
    fi

    export OPENROUTER_API_KEY="$(${pkgs.coreutils}/bin/cat "$secret_path")"
    export OPENCODE_CONFIG_DIR="${aiWorkspace}/config"
    export AI_WORKSPACE_PYTHON="${pkgs.python3}/bin/python3"

    exec ${pkgs.opencode}/bin/opencode "$@"
  '';
in
{
  home.packages = [
    opencodeWrapper
    workspaceWrapper
    workspaceValidateWrapper
    workspaceTestWrapper
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
