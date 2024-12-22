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
    btop
    cheat
    cifs-utils
    curl
    dua
    fzf
    git
    miniserve
    p7zip
    qbittorrent-nox
    silver-searcher
    sqlite
    tmux
    yt-dlp
  ];

  security.sudo.extraConfig = ''
    Defaults         timestamp_timeout=30
  '';

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Amsterdam";

  networking.hostName = "andromeda";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "virtio_gpu" ];
  boot.kernelParams = [ "console=tty" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.tailscale.enable = true;

  services.openssh = {
    enable = true;
    authorizedKeysCommandUser = "nobody";
    settings = {
      GSSAPIAuthentication = false;
      KerberosAuthentication = false;
      PasswordAuthentication = false;
      PermitEmptyPasswords = false;
      PermitRootLogin = "no";
      PubkeyAuthentication = true;
      UsePAM = true;
      X11Forwarding = false;
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 6881 ];
  networking.firewall.allowedUDPPorts = [ 6881 ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.stateVersion = "24.05";
}
