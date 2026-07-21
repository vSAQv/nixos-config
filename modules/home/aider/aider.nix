{
  config,
  pkgs,
  ...
}: {
  home.packages = [
    (pkgs.writeShellScriptBin "aider" ''
      SECRET_PATH="/run/secrets/OPENROUTER_API_KEY"

      if [ -f "$SECRET_PATH" ]; then
        export OPENROUTER_API_KEY=$(cat "$SECRET_PATH")
      else
        echo "Error: SOPS secret not found at $SECRET_PATH" >&2
        exit 1
      fi

      exec ${pkgs.aider-chat}/bin/aider "$@"
    '')
  ];

  home.file.".aider.conf.yml".text = ''
    # --- Model Routing ---
    model: openrouter/nvidia/nemotron-3-ultra:free

    # --- Architect Mode ---
    architect: true
    editor-model: openrouter/poolside/laguna-m.1:free

    # --- Context Management ---
    map-tokens: 2048
    aiderignore: ".aiderignore"

    # --- Aliases ---
    aliases:
      free: openrouter/nvidia/nemotron-3-ultra:free
      deep: openrouter/deepseek/deepseek-v4-pro
      luna: openrouter/openai/gpt-5.6-luna
      sol: openrouter/openai/gpt-5.6-sol

    # --- Git ---
    auto-commits: false
    commit-prompt: "Generate a concise, conventional commit message for these changes."

    # --- UI ---
    stream: true
    dark-mode: true

    # --- Linting ---
    auto-lint: true
    lint-cmd:
      "*.nix": "nixpkgs-fmt"
      "*.yaml": "yamllint"
      "*.yml": "yamllint"
      "*.sh": "shellcheck"

    read:
      - "/home/cif/nixos-config/modules/home/aider/.aider.rules.md"
  '';
}
