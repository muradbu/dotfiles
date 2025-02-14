{ config, pkgs, lib, ... }:

{
  users.groups.murad = {
    gid = 1000;
  };

  users.users.murad = {
    isNormalUser = true;
    group = "murad";
    extraGroups = [ "docker" "wheel" "video" "render" ];
    packages = with pkgs; [ ];
    linger = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHzXuAP+Ii/FNTdSWdJgtppL1WNdzDwcPmHEQ3UxYMHu murad@kunafa"
    ];
  };

  security.sudo.extraConfig = ''
    Defaults:murad          timestamp_timeout=30
  '';
}
