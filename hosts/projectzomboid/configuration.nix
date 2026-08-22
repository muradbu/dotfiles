{ config, pkgs, ... }:

{
  imports = [
    ../lxc-shared.nix
  ];

  networking.hostName = "projectzomboid";

  environment.systemPackages = with pkgs; [
    steamcmd
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    glibc
    zlib
    libgcc
  ];
}
