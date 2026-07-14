{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    #    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./shared.nix
  ];

  # LXC-specific settings
  boot.isContainer = true;

  # Trusted LAN containers; Proxmox handles isolation.
  networking.firewall.enable = false;

  networking = {
    useDHCP = lib.mkDefault true;
    useHostResolvConf = false;
  };

  # Fix to make Proxmox's web-based terminal emulator work
  systemd.services."serial-getty@ttyS0".enable = true;
}
