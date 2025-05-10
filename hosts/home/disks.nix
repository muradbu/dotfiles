{ ... }:
{
  fileSystems."/mnt/data01" = {
    device = "/dev/disk/by-label/data01";
    fsType = "xfs";
  };

  fileSystems."/mnt/data02" = {
    device = "/dev/disk/by-label/data02";
    fsType = "xfs";
  };
}
