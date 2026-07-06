# /home/cif/nixos-config/modules/home/homeLab/k3s.nix
{
  config,
  pkgs,
  ...
}: {
  # --- Declarative K3s Server Configuration ---
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--disable traefik"
    ];
  };

  environment.systemPackages = with pkgs; [
    argocd
    k3s
  ];

  # --- Generate Kubernetes Secret from SOPS ---
  sops.templates."homelab-secrets.yaml".content = ''
    apiVersion: v1
    kind: Secret
    metadata:
      name: homelab-secrets
      namespace: default
    type: Opaque
    stringData:
      TZ: "${config.sops.placeholder."TZ"}"
      GEMINI_KEY: "${config.sops.placeholder."GEMINI_KEY"}"
      PROTON_KEY: "${config.sops.placeholder."PROTON_KEY"}"
      SPOTIFY_ID: "${config.sops.placeholder."SPOTIFY_ID"}"
      SPOTIFY_SECRET: "${config.sops.placeholder."SPOTIFY_SECRET"}"
      LASTFM_KEY: "${config.sops.placeholder."LASTFM_KEY"}"
      LASTFM_SECRET: "${config.sops.placeholder."LASTFM_SECRET"}"
      SL_SL_USERNAME: "${config.sops.placeholder."SL_SL_USERNAME"}"
      SL_SL_PASSWORD: "${config.sops.placeholder."SL_SL_PASSWORD"}"
      SL_USERNAME: "${config.sops.placeholder."SL_USERNAME"}"
      SL_PASSWORD: "${config.sops.placeholder."SL_PASSWORD"}"
      TS_KEY: "${config.sops.placeholder."TS_KEY"}"
      PROXY_FULL_AUTH: "${config.sops.placeholder."PROXY_FULL_AUTH"}"
      IMMICH_DB_PASSWORD: "${config.sops.placeholder."IMMICH_DB_PASSWORD"}"
      GV_DB_PASS: "${config.sops.placeholder."GV_DB_PASS"}"
      JWT_SECRET_KEY: "${config.sops.placeholder."JWT_SECRET_KEY"}"
      RAWG_KEY: "${config.sops.placeholder."RAWG_KEY"}"
      PL_DB_PASS: "${config.sops.placeholder."PL_DB_PASS"}"
      PL_DB_ROOT_PASS: "${config.sops.placeholder."PL_DB_ROOT_PASS"}"
      PL_APP_KEY: "${config.sops.placeholder."PL_APP_KEY"}"
  '';

  # --- Zero-Touch Provisioning (Auto-Deploy Manifests) ---
  systemd.services.k3s-bootstrap = {
    description = "Bootstrap K3s with ArgoCD and SOPS Secrets";
    before = ["k3s.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /var/lib/rancher/k3s/server/manifests

      # Provide generated secrets to the K3s auto-deploy controller
      cp ${config.sops.templates."homelab-secrets.yaml".path} /var/lib/rancher/k3s/server/manifests/homelab-secrets.yaml

      # Declarative ArgoCD Helm Chart installation
      cat <<EOF > /var/lib/rancher/k3s/server/manifests/argocd.yaml
      apiVersion: helm.cattle.io/v1
      kind: HelmChart
      metadata:
        name: argocd
        namespace: kube-system
      spec:
        chart: argo-cd
        repo: https://argoproj.github.io/argo-helm
        targetNamespace: argocd
        createNamespace: true
      EOF

      # Declarative GitOps Root Application mapping
      cat <<EOF > /var/lib/rancher/k3s/server/manifests/root-app.yaml
      apiVersion: argoproj.io/v1alpha1
      kind: Application
      metadata:
        name: root-apps
        namespace: argocd
      spec:
        project: default
        source:
          # IMPORTANT: Replace with your actual K8s GitOps repository URL
          repoURL: 'git@github.com:USER/k8s-gitops.git'
          path: apps
          targetRevision: HEAD
          directory:
            recurse: true
        destination:
          server: 'https://kubernetes.default.svc'
          namespace: default
        syncPolicy:
          automated:
            prune: true
            selfHeal: true
      EOF
    '';
  };

  # Required for K3s API server
  networking.firewall.allowedTCPPorts = [6443];
}
