{
  config,
  pkgs,
  lib,
  nixos-raspberrypi,
  ...
}:

{
  imports = with nixos-raspberrypi.nixosModules; [
    raspberry-pi-5.base
    raspberry-pi-5.display-vc4
    raspberry-pi-5.bluetooth
    ../shared.nix
  ];

  networking.hostName = "pi";

  # Generational bootloader. The Pi 5 base module still defaults to the legacy
  # "kernelboot"; "kernel" is what upstream recommends for new installs and what
  # its SD images use, so keep the installed system on the same one.
  boot.loader.raspberry-pi.bootloader = "kernel";

  # Partition labels written by the nixos-raspberrypi installer image.
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "noatime" ];
    };
    "/boot/firmware" = {
      device = "/dev/disk/by-label/FIRMWARE";
      fsType = "vfat";
      options = [
        "noatime"
        "noauto"
        "x-systemd.automount"
        "x-systemd.idle-timeout=1min"
      ];
    };
  };

  # Label generations with board/bootloader/kernel so `nixos-rebuild` history is
  # readable in the boot menu.
  system.nixos.tags =
    let
      cfg = config.boot.loader.raspberry-pi;
    in
    [
      "raspberry-pi-${cfg.variant}"
      cfg.bootloader
      config.boot.kernelPackages.kernel.version
    ];
}
