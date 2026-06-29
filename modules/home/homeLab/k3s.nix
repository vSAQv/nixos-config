# /home/cif/nixos-config/modules/home/homeLab/k3s.nix
{
  config,
  pkgs,
  ...
}: {
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString ["--disable traefik"];
  };

  environment.systemPackages = with pkgs; [
    argocd
    k3s
  ];

  sops.templates."homelab-secrets.yaml".content = ''
    apiVersion: v1
    kind: Secret
    metadata:
      name: homelab-secrets
      namespace: default
    type: Opaque
    stringData:
      GEMINI_KEY: "${config.sops.placeholder."homelab/GEMINI_KEY"}"
      PROTON_KEY: "${config.sops.placeholder."homelab/PROTON_KEY"}"
      SPOTIFY_ID: "${config.sops.placeholder."homelab/SPOTIFY_ID"}"
      SPOTIFY_SECRET: "${config.sops.placeholder."homelab/SPOTIFY_SECRET"}"
      LASTFM_KEY: "${config.sops.placeholder."homelab/LASTFM_KEY"}"
      LASTFM_SECRET: "${config.sops.placeholder."homelab/LASTFM_SECRET"}"
      SL_SL_USERNAME: "${config.sops.placeholder."homelab/SL_SL_USERNAME"}"
      SL_SL_PASSWORD: "${config.sops.placeholder."homelab/SL_SL_PASSWORD"}"
      SL_USERNAME: "${config.sops.placeholder."homelab/SL_USERNAME"}"
      SL_PASSWORD: "${config.sops.placeholder."homelab/SL_PASSWORD"}"
      TS_KEY: "${config.sops.placeholder."homelab/TS_KEY"}"
      PROXY_FULL_AUTH: "${config.sops.placeholder."homelab/PROXY_FULL_AUTH"}"
      IMMICH_DB_PASSWORD: "${config.sops.placeholder."homelab/IMMICH_DB_PASSWORD"}"
      GV_DB_PASS: "${config.sops.placeholder."homelab/GV_DB_PASS"}"
      JWT_SECRET_KEY: "${config.sops.placeholder."homelab/JWT_SECRET_KEY"}"
      RAWG_KEY: "${config.sops.placeholder."homelab/RAWG_KEY"}"
      PL_DB_PASS: "${config.sops.placeholder."homelab/PL_DB_PASS"}"
      PL_DB_ROOT_PASS: "${config.sops.placeholder."homelab/PL_DB_ROOT_PASS"}"
      PL_APP_KEY: "${config.sops.placeholder."homelab/PL_APP_KEY"}"
  '';

  systemd.services.apply-k8s-secrets = {
    description = "Apply SOPS secrets to k3s";
    after = ["k3s.service"];
    requires = ["k3s.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      until ${pkgs.k3s}/bin/k3s kubectl get nodes; do
        sleep 2
      done
      ${pkgs.k3s}/bin/k3s kubectl apply -f ${config.sops.templates."homelab-secrets.yaml".path}
    '';
  };

  networking.firewall.allowedTCPPorts = [6443];
}
