{ ... }:
{
  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-label/data";
    fsType = "xfs";
  };
}
