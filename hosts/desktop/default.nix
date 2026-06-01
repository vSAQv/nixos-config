{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
    inputs.chaotic.nixosModules.default
  ];

  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  powerManagement.cpuFreqGovernor = "performance";
}

