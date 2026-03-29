{ config, pkgs, ... }:

{
  imports = [
    ../lxc-shared.nix
  ];

  environment.systemPackages = with pkgs; [
    lftp
  ];
}
