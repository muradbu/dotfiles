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

  systemd.services.netiso = {
    enable = true;
    description = "NetISO Server for Xbox 360";

    # This ensures the service starts automatically on boot
    wantedBy = [ "multi-user.target" ];

    # Wait for the network to be up before starting
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = "/home/murad/netiso-srv -r";

      WorkingDirectory = "/home/murad/games/xbox360/extracted";
      User = "murad";

      # Ninja standard: Auto-restart if the server crashes
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

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
