{ config, pkgs, ... }:

{
  imports = [
    ../lxc-shared.nix
  ];

  environment.systemPackages = with pkgs; [
    lftp
    _7zz
    maxcso
  ];

  services.vsftpd = {
    enable = true;
    localUsers = true;
    writeEnable = true;
    chrootlocalUser = true;
    extraConfig = ''
      pasv_enable=YES
    '';

    anonymousUser = true;
    anonymousUserNoPassword = true;
    anonymousUserHome = "/home/murad/games";
  };
}
