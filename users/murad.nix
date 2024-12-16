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
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJo4Wv8qkH5XcPamuGCFZQg24YW+JTUtgYzYuNBF4tim murad@S10"
    ];
  };

  security.sudo.extraConfig = ''
    Defaults:murad          timestamp_timeout=30
  '';
}
