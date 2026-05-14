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
      ExecStart = "/home/murad/.local/bin/netiso-srv . -r -b";

      WorkingDirectory = "/home/murad/games/xbox360/extracted";
      User = "murad";

      # Ninja standard: Auto-restart if the server crashes
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };

  services.samba = {
    enable = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "NixOS-Retro-Server";
        "security" = "user";

        # Support everything from PS2 (NT1) to Windows 11 (SMB3)
        "server min protocol" = "NT1";
        "ntlm auth" = "yes";

        # Required for symlinks
        "unix extensions" = "no";
      };

      "PS2SMB" = {
        "path" = "/home/murad/games/ps2/extracted";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "force user" = "murad";
        "follow symlinks" = "yes";
        "wide links" = "yes";
        # OPL performance tweak:
        "socket options" = "TCP_NODELAY IPTOS_LOWDELAY";
      };
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
