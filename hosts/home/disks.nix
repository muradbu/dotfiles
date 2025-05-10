{ ... }:
{
  # Decrypting and mounting luks encrypted disks in the front bays

  environment.etc.crypttab = {
    mode = "0600";
    text = ''
      # data01 /dev/mapper/data01 /root/data01.key
      data01 UUID=edc55baf-dc30-4730-acb5-346d998ef511 /root/data01.key
    '';
  };

  fileSystems."/mnt/data01" = {
    device = "/dev/mapper/data01";
    fsType = "xfs";
  };
}
