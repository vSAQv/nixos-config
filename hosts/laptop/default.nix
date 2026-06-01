{
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./../../modules/core
    inputs.chaotic.nixosModules.default
  ];

  environment.systemPackages = with pkgs; [
    acpi
    brightnessctl
    #cpupower-gui
    powertop
  ];
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  services = {
    power-profiles-daemon.enable = true;
    thermald.enable = true;

    upower = {
      enable = true;
      percentageLow = 20;
      percentageCritical = 5;
      percentageAction = 3;
      criticalPowerAction = "PowerOff";
    };

    undervolt = {
      enable = true;

      p1 = {
        limit = 45;
        window = 28;
      };

      p2 = {
        limit = 55;
        window = 2;
      };
    };

    #tlp.settings = {
    # CPU_ENERGY_PERF_POLICY_ON_AC = "power";
    # CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

    # CPU_BOOST_ON_AC = 1;
    # CPU_BOOST_ON_BAT = 1;

    # CPU_HWP_DYN_BOOST_ON_AC = 1;
    # CPU_HWP_DYN_BOOST_ON_BAT = 1;

    # PLATFORM_PROFILE_ON_AC = "performance";
    # PLATFORM_PROFILE_ON_BAT = "performance";

    # INTEL_GPU_MIN_FREQ_ON_AC = 500;
    # INTEL_GPU_MIN_FREQ_ON_BAT = 500;
    # INTEL_GPU_MAX_FREQ_ON_AC=0;
    # INTEL_GPU_MAX_FREQ_ON_BAT=0;
    # INTEL_GPU_BOOST_FREQ_ON_AC=0;
    # INTEL_GPU_BOOST_FREQ_ON_BAT=0;

    #PCIE_ASPM_ON_AC = "default";
    #PCIE_ASPM_ON_BAT = "powersupersave";
  };

  systemd.services.force-power-saver = {
    description = "Force power-saver profile on boot";
    wantedBy = ["multi-user.target"];
    after = ["power-profiles-daemon.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver";
    };
  };

  #powerManagement.cpuFreqGovernor = "performance";
  powerManagement.powertop.enable = true;

  boot = {
    kernelModules = ["acpi_call"];
    kernelPackages = pkgs.linuxPackages_cachyos;
    kernelParams = [
      "pcie_aspm=force"
      "nmi_watchdog=0"
      "i915.enable_psr=1"
      "i915.enable_fbc=1"
    ];
    extraModulePackages = with config.boot.kernelPackages;
      [
        acpi_call
        #cpupower
      ]
      ++ [pkgs.cpupower-gui];
  };
}
