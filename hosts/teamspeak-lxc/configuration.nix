{ config, ... }:

{
  imports = [
    ../lxc-shared.nix
  ];

  networking.hostName = "teamspeak";

  services.teamspeak3 = {
    enable = true;
  };
}
