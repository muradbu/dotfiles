{ pkgs, self, config, ... }:

{
  imports = [
    ./hardware-configuration.nix
    "${self}/packages/neovim"
    "${self}/users/murad.nix"
    "${self}/hosts/shared"
  ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  home-manager.users.murad = { pkgs, ... }: {
    #home.packages = with pkgs; [ ];

    home.stateVersion = "24.05";
  };

  environment.systemPackages = with pkgs; [
    btop
    cheat
    cifs-utils
    curl
    dua
    eza
    fd
    fzf
    git
    miniserve
    p7zip
    qbittorrent-nox
    silver-searcher
    sqlite
    tmux
    yt-dlp
    z-lua
  ];

  sops.secrets.autobrrSessionSecret = {};
  systemd.services.autobrr.serviceConfig.LoadCredential = "autobrrSessionSecret:${config.sops.secrets.autobrrSessionSecret.path}";
  services.autobrr = {
    enable = true;
    secretFile = "/run/credentials/autobrr.service/autobrrSessionSecret";
    settings = {
      host = "100.108.106.31";
      port = "7474";
    };
  };

  services.rtorrent = {
    enable = true;
    port = 60000;
    user = "murad";
    group = "murad";
    dataDir = "/home/murad/.config/rtorrent";
    openFirewall = true;
    downloadDir = "/home/murad/mnt/downloads";
    configText = "";
  };

  #services.rutorrent = {
  #  enable = true;
  #  dataDir = "/home/murad/.config/rutorrent";
  #  hostName = "rutorrent.muradb.com";
  #  #user = "murad";
  #  #group = "murad";
  #};

  programs.bat = {
    enable = true;
  };

  services.caddy = {
    enable = true;

    virtualHosts."jellyfin.muradb.com".extraConfig = ''
      reverse_proxy :8096
    '';
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    configDir = "/home/murad/.config/jellyfin";
    cacheDir = "/home/murad/mnt/cache/jellyfin";
    group = "murad";
    user = "murad";
  };

  #services.flaresolverr = {
  #  enable = false;
  #  openFirewall = true;
  #};

  #services.prowlarr = {
  #  enable = true;
  #  openFirewall = true;
  #};

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

  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 80 443 6881 ];
  networking.firewall.allowedUDPPorts = [ 80 443 6881 ];
  # Or disable the firewall altogether.
  #networking.firewall.enable = false;

  system.stateVersion = "24.05";
}
