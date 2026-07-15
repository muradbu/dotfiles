{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:

{
  imports = [
    # Enables boot.loader.initScript so /sbin/init is rewritten on every
    # rebuild — without it the container reverts to the template system on
    # every restart. Also defers network setup to Proxmox (systemd-networkd).
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
    ./shared.nix
  ];

  # Keep hostnames from this repo instead of Proxmox's /etc/hostname.
  proxmoxLXC.manageHostName = true;

  # Trusted LAN containers; Proxmox handles isolation.
  networking.firewall.enable = false;

  # Fix to make Proxmox's web-based terminal emulator work
  systemd.services."serial-getty@ttyS0".enable = true;
}
