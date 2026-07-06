{...}: {
  imports = [
    ./declaration.nix
    ./k3s.nix
    #./sync.nix
    ./secrets.yaml
  ];
}
