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
    model: openrouter/qwen/qwen3-coder:free

    # --- Architect Mode ---
    architect: true
    editor-model: openrouter/qwen/qwen3-coder:free

    # --- Context Management ---
    map-tokens: 2048
    aiderignore: ".aiderignore"

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
