{ config, pkgs, ... }:

let
  # Keep the OpenRouter key in sops-nix. OpenCode reads the decrypted file
  # at runtime; the secret value never enters the Nix store.
  openrouterKeyFile = config.sops.secrets.openrouter_api_key.path;
in
{
  sops.secrets.openrouter_api_key = {
    # Reuse the existing SOPS file for MODULE 01.
    # The key is expected to be named OPENROUTER_API_KEY.
    # We can move this to a dedicated AI secrets file in a later module.
    sopsFile = ../../core/homeLab/secrets.yaml;
    key = "OPENROUTER_API_KEY";
  };

  programs.opencode = {
    enable = true;
    package = pkgs.opencode;

    settings = {
      "$schema" = "https://opencode.ai/config.json";

      # Package/version is controlled by NixOS/Home Manager.
      autoupdate = false;

      # Primary model for MODULE 01.
      model = "openrouter/deepseek/deepseek-v4-flash";

      provider.openrouter = {
        options = {
          apiKey = "{file:${openrouterKeyFile}}";
        };

        models = {
          "deepseek/deepseek-v4-flash" = {
            name = "DeepSeek V4 Flash";

            # Cost-safety for the initial setup: do not silently fail over
            # this large-context request to another OpenRouter provider.
            # A richer routing policy will be introduced later.
            options.provider.allow_fallbacks = false;
          };
        };
      };
    };
  };
}
