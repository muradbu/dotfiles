{ config }:

{
  imports = [
    ../lxc-shared.nix
  ];

  services.teamspeak3 = {
    enable = true;
  };
}
