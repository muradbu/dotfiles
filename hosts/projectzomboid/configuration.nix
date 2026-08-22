{ config, pkgs, ... }:

{
  imports = [
    ../lxc-shared.nix
  ];

  networking.hostName = "projectzomboid";

  environment.systemPackages = with pkgs; [
    steamcmd
  ];
}
