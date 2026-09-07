{ pkgs, ... }:

let
  aiWorkspace = "/home/cif/Projects/ai-workspace";
in
{
  home.packages = [
    (pkgs.writeShellScriptBin "opencode" ''
      set -euo pipefail

      secret_path="/run/secrets/OPENROUTER_API_KEY"
      if [ ! -r "$secret_path" ]; then
        echo "OpenRouter secret is missing or unreadable: $secret_path" >&2
        exit 1
      fi

      export OPENROUTER_API_KEY="$(cat "$secret_path")"
      export OPENCODE_CONFIG_DIR="${aiWorkspace}/config"

      exec ${pkgs.opencode}/bin/opencode "$@"
    '')
  ];
}
