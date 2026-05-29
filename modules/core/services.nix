{...}: {
  services = {
    tailscale.enable = true;
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    dbus.enable = true;
    udisks2.enable = true;
    fstrim.enable = true;
    #zapret = {
    #  enable = true;
    #  params = [
    #    "--dpi-desync=fake,split2 --dpi-desync-ttl=5"
    #  ];
    #};
  };
  services.logind = {
    settings.Login = {
      # don’t shutdown when power button is short-pressed
      HandlePowerKey = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      LidSwitchIgnoreInhibited = "no";
      IdleAction = "ignore";
    };
  };
}
