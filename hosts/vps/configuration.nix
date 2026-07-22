{
  pkgs,
  self,
  config,
  lib,
  ...
}:
let
  datamnt = "/mnt/data";
in
{
  imports = [
    ./hardware-configuration.nix
    ../shared.nix
  ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  environment.systemPackages = with pkgs; [
    cheat
    cifs-utils
    sshfs
    dua
    fd
    fzf
    miniserve
    p7zip
    silver-searcher-ng
    sqlite
    qbittorrent-nox
    yt-dlp
  ];

  services.vsftpd = {
    enable = true;
    localUsers = true;
    writeEnable = true;
    chrootlocalUser = true;
    extraConfig = ''
      pasv_enable=YES
    '';

    anonymousUser = true;
    anonymousUserNoPassword = true;
    anonymousUserHome = "/mnt/data/data";
  };

  sops.secrets.autobrrSessionSecret = { };
  #systemd.services.autobrr.serviceConfig.LoadCredential = "autobrrSessionSecret:${config.sops.secrets.autobrrSessionSecret.path}";
  services.autobrr = {
    enable = true;
    secretFile = config.sops.secrets.autobrrSessionSecret.path;
    settings = {
      host = "0.0.0.0";
      port = 7474;
    };
  };

  # Some temporary workaround because dasel is fucked, for autobrr
  systemd.services.autobrr.serviceConfig.ExecStartPre =
    let
      configFormat = pkgs.formats.toml { };
      configTemplate = configFormat.generate "autobrr.toml" config.services.autobrr.settings;
    in
    lib.mkForce [
      # Replaces the broken dasel v3 syntax with a robust yq-go command
      "${pkgs.bash}/bin/bash -c 'SECRET=\"$$(${config.systemd.package}/bin/systemd-creds cat sessionSecret)\" ${lib.getExe pkgs.yq-go} -p toml -o toml \".sessionSecret = env(SECRET)\" \"${configTemplate}\" > %S/autobrr/config.toml'"
    ];

  services.qbittorrent = {
    enable = false;
    user = "murad";
    group = "murad";
    extraArgs = [ "--confirm-legal-notice" ];
    webuiPort = 50000;
    torrentingPort = 6881;
    serverConfig = {
      LegalNotice.Accepted = true;
      BitTorrent = {
        Session = {
          DHTEnabled = false;
          #DefaultSavePath = ""
        };
      };
      Preferences = {
        WebUI = {
          Username = "murad";
          Password_PBKDF2 = "@ByteArray(zr9tCNaFnkzF2cXt8dPeow==:A9c6xTkJbH/FR4/LVIm6AW978V/V518ehPxzEURXspxCPDGlaiOkFvAh+FS4r5YiJOgDWWkk6B+VvFRteFkgwQ==)";
        };
        General.Locale = "en";
      };
    };
  };

  services.rtorrent = {
    enable = false;
    port = 60000;
    user = "murad";
    group = "murad";
    dataDir = "/home/murad/.config/rtorrent";
    openFirewall = true;
    downloadDir = "${datamnt}/downloads";
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

  sops.secrets.cloudflareApiToken = { };
  sops.templates."caddy-cloudflare.env".content = ''
    CLOUDFLARE_API_TOKEN="${config.sops.placeholder.cloudflareApiToken}"
  '';

  systemd.services.caddy.serviceConfig.EnvironmentFile = [
    config.sops.templates."caddy-cloudflare.env".path
  ];

  services.caddy = {
    enable = true;
    package = pkgs.caddy.withPlugins {
      plugins = [ "github.com/caddy-dns/cloudflare@v0.2.3" ];
      hash = "sha256-peY/XG37RC0e7FafJ3qNk53srtXZagxN/Hfexcc2TMM=";
    };

    # Cloudflare's published ranges (https://www.cloudflare.com/ips/); trusted
    # so X-Forwarded-For from the Cloudflare proxy carries the real client IP
    # through to upstreams for proxied hosts like egelrace.muradb.com.
    globalConfig = ''
      servers {
        trusted_proxies static 173.245.48.0/20 103.21.244.0/22 103.22.200.0/22 103.31.4.0/22 141.101.64.0/18 108.162.192.0/18 190.93.240.0/20 188.114.96.0/20 197.234.240.0/22 198.41.128.0/17 162.158.0.0/15 104.16.0.0/13 104.24.0.0/14 172.64.0.0/13 131.0.72.0/22 2400:cb00::/32 2606:4700::/32 2803:f800::/32 2405:b500::/32 2405:8100::/32 2a06:98c0::/29 2c0f:f248::/32
      }
    '';

    virtualHosts."egelrace.muradb.com".extraConfig = ''
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }

      reverse_proxy :3000
    '';

    virtualHosts."autobrr.vps.muradb.com".extraConfig = ''
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }

      reverse_proxy :7474
    '';

    virtualHosts."prowlarr.vps.muradb.com".extraConfig = ''
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }

      reverse_proxy :9696
    '';

    virtualHosts."qbittorrent.vps.muradb.com".extraConfig = ''
      tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
      }

      reverse_proxy :50000
    '';
  };

  services.seerr = {
    enable = false;
    port = 5055;
  };

  services.jellyfin = {
    enable = false;
    openFirewall = true;
  };

  sops.secrets.andromedaRadarrApiKey = { };
  sops.secrets.andromedaSonarrApiKey = { };
  services.recyclarr = {
    enable = false;
    configuration = {
      radarr = [
        {
          api_key._secret = config.sops.secrets.andromedaRadarrApiKey.path;
          base_url = "http://localhost:${builtins.toString config.services.radarr.settings.server.port}";
          instance_name = "main";
        }
      ];
      sonarr = [
        {
          api_key._secret = config.sops.secrets.andromedaSonarrApiKey.path;
          base_url = "http://localhost:${builtins.toString config.services.sonarr.settings.server.port}";
          instance_name = "main";
        }
      ];
    };
  };

  services.prowlarr = {
    enable = false;
    settings.server.port = 9696;
  };

  services.radarr = {
    enable = false;
    user = "murad";
    group = "murad";
    dataDir = "/home/murad/.config/radarr";
    settings.server.port = 7878;
  };

  services.sonarr = {
    enable = false;
    user = "murad";
    group = "murad";
    dataDir = "/home/murad/.config/sonarr";
    settings.server.port = 8989;
  };

  #services.flaresolverr = {
  #  enable = false;
  #  openFirewall = true;
  #};

  networking.hostName = "andromeda";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "virtio_gpu" ];
  boot.kernelParams = [ "console=tty" ];

  services.tailscale.enable = true;

  #services.changedetection-io = {
  #  enable = true;
  #  user = "murad";
  #  group = "murad";
  #  datastorePath = "/home/murad/.config/changedetection-io";
  #};

  fileSystems."${datamnt}" = {
    # Syntax: user@host:/path
    # We use ":/backup" to match your previous CIFS path, but ":/" would mount the whole box.
    device = "u417181@u417181.your-storagebox.de:/home";
    fsType = "sshfs";

    options = [
      # --- Systemd Automount (Keep these! They prevent boot hangs) ---
      "x-systemd.automount"
      "noauto"
      "x-systemd.idle-timeout=60"
      "x-systemd.device-timeout=5s"
      "x-systemd.mount-timeout=5s"
      "_netdev"

      # --- SSH Connection Settings ---
      "allow_other" # Vital: Lets your torrent user see the mount
      "IdentityFile=/etc/nixos/storagebox_key" # The key we made in step 1
      "Port=23" # SFTP Port (as seen in your screenshot)
      "reconnect" # Reconnect if the internet blips
      "ServerAliveInterval=15" # Keep connection alive every 15s

      # --- Performance & Permissions (The "Fix") ---
      "uid=1000" # Map remote files to your local user
      "gid=1000" # Map remote files to your local group
      "cache=yes" # Use RAM caching to reduce network chatter
      "kernel_cache" # Allow the kernel to cache file metadata
      "noatime"
      "compression=no" # Disable compression to save CPU
      "cipher=aes128-gcm@openssh.com" # Use the fastest encryption cipher
    ];
  };

  # Internet-facing host: harden sshd beyond the shared.nix baseline.
  services.openssh.settings = {
    GSSAPIAuthentication = false;
    KerberosAuthentication = false;
    PermitEmptyPasswords = false;
    PubkeyAuthentication = true;
    UsePAM = true;
    X11Forwarding = false;
  };

  virtualisation.docker.enable = true;

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  nix.gc = {
    dates = "daily";
    options = "--delete-older-than 7d";
  };

  services.journald.extraConfig = ''
    SystemMaxUse=100M
  '';

  boot.kernel.sysctl = {
    # --- Network Speed (BBR) ---
    # BBR is essential for maintaining speed over WAN (VPS <-> Storage Box)
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";

    # --- Virtual Memory Tuning (Prevent Stalls) ---
    # Swappiness 100? Yes. With ZRAM, we WANT to swap aggressively
    # to move cold data into compressed RAM and keep active RAM free for caching.
    "vm.swappiness" = 100;

    # Increase pressure on cache to keep directory listings in RAM
    "vm.vfs_cache_pressure" = 50;

    # --- Dirty Pages (Write Caching) ---
    # Start writing to disk/network earlier to avoid massive spikes that freeze the VPS
    "vm.dirty_background_ratio" = 5;
    "vm.dirty_ratio" = 10;
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
    6881
  ];
  networking.firewall.allowedUDPPorts = [ 6881 ];
  # Services not exposed publicly (FTP, *arr web UIs) are reached over
  # tailscale, so exempt that interface from filtering.
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  system.stateVersion = "24.05";
}
