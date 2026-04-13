{
  config,
  pkgs,
  lib,
  self,
  ...
}:

{
  imports = [
    ../users/murad.nix
  ];

  environment.systemPackages = with pkgs; [
    bat
    btop
    curl
    eza
    git
    tmux
    wget
    self.packages.${pkgs.stdenv.hostPlatform.system}.neovim
  ];

  environment.enableAllTerminfo = true;

  environment.localBinInPath = true;

  environment.shellAliases = {
    cat = "bat";
    dps = "docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'";
    ls = "eza -lghHbm --git --icons --time-style=long-iso --group-directories-first";
    lsblk = "lsblk -o name,fstype,size,fsused,fsavail,fsuse%,mountpoints";

    ga = "git add";
    gc = "git commit";
    gco = "git checkout";
    gcp = "git cherry-pick";
    gdiff = "git diff";
    gl = "git prettylog";
    gp = "git push";
    gs = "git status";
    gt = "git tag";
  };

  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  environment.variables.EDITOR = "nvim";

  networking.firewall.enable = false;

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "no";
    settings.PasswordAuthentication = false;
  };

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [ "@wheel" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  documentation.enable = false;
  documentation.nixos.enable = false;

  system.stateVersion = "25.11";
}
