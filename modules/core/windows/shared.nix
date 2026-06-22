{
  config,
  lib,
  pkgs,
  ...
}: {
  fileSystems."/mnt/shared" = {
    device = "/dev/disk/by-uuid/04623DBB25806C30";
    fsType = "ntfs3";
    options = [
      "rw"
      "uid=1000"
      "gid=100"
      "dmask=0022"
      "fmask=0022"
      "windows_names"
      "exec"
      "nofail"
      "comment=x-gvfs-show"
    ];
  };
}
