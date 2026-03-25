{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./shared.nix
  ];

  # Boot
  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
    "virtio_blk"
  ];

  boot.growPartition = true;

  # Filesystem — adjust device/label to match your template
  fileSystems."/" = {
    device = "/dev/vda1";
    fsType = "ext4";
    autoResize = true;
  };

  # Networking
  networking.useDHCP = lib.mkDefault true;

  # QEMU Guest Agent for Proxmox integration (shutdown, freeze, info)
  services.qemuGuest.enable = true;
}
