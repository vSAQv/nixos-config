{
  config,
  pkgs,
  username,
  ...
}:
{
  # Add user to libvirtd group
  users.users.${username}.extraGroups = [ "libvirtd" ];

  # Install necessary packages
  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    adwaita-icon-theme
  ];

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      registry-mirrors = [
        "https://mirror.gcr.io"
        "https://daocloud.io"
        "https://huecker.io"
        "https://dockerhub.timeweb.cloud"
        "https://docker.m.daocloud.io"
        "https://mirror.iscas.ac.cn"
        "https://mirror.nju.edu.cn"

      ];
    };
  };

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Manage the virtualisation services
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  services.spice-vdagentd.enable = true;
}
