{ pkgs, ... }:

{
  users.groups.murad = {
    gid = 1000;
  };

  users.users.murad = {
    isNormalUser = true;
    group = "murad";
    home = "/home/murad";
    extraGroups = [ "docker" "wheel" "video" "render" "libvirtd" ];
    packages = with pkgs; [ ];
    linger = true;
    initialHashedPassword = "$y$j9T$9EyXxMMX92mW9qu0pjEFC/$Elr3r7SRzJNciCJKoshwGCxZ5OyNR.Z1LhI47lNnth6";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHzXuAP+Ii/FNTdSWdJgtppL1WNdzDwcPmHEQ3UxYMHu murad@kunafa"
    ];
  };

  security.sudo.extraConfig = ''
    Defaults:murad          timestamp_timeout=30
  '';
  
}
