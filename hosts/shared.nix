{
  config,
  pkgs,
  lib,
  self,
  ...
}:

{
  imports = [
    ../modules/common.nix
    ../users/murad.nix
  ];

  environment.enableAllTerminfo = true;

  environment.localBinInPath = true;

  environment.shellAliases = {
    lsblk = "lsblk -o name,fstype,size,fsused,fsavail,fsuse%,mountpoints";
  };

  programs.fzf = {
    keybindings = true;
    fuzzyCompletion = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.ssh.startAgent = true;

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
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 30d";
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  documentation.enable = false;
  documentation.nixos.enable = false;

  system.stateVersion = lib.mkDefault "25.11";
}
