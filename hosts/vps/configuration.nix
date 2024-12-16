{ pkgs, nixpkgs-unstable, self, ... }:

{
  imports = [
    ./hardware-configuration.nix
    "${self}/packages/neovim"
    "${self}/users/murad.nix"
  ];

  home-manager.users.murad = { pkgs, ... }: {
    home.packages = with pkgs; [ ];

    home.stateVersion = "24.05";
  };

  environment.systemPackages = with pkgs; [
    yt-dlp
    dua
    fzf
  ];

  security.sudo.extraConfig = ''
    Defaults         timestamp_timeout=30
  '';

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Amsterdam";

  networking.hostName = "andromeda";
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.05";
}
