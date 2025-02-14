{ pkgs, nixpkgs-unstable, self, ... }:

{
  imports = [
    "${self}/packages/neovim"
    "${self}/hosts/shared"
  ];

  ids.gids.nixbld = 350;

  users.users.murad = {
    name = "murad";
    home = "/Users/murad";
  };

  home-manager.users.murad = { pkgs, ... }: {
    home.packages = with pkgs; [ ];

    home.stateVersion = "24.05";
  };

  environment.systemPackages = with pkgs; [
    age
    bat
    sops
    #prismlauncher
    #steam
    #ums
    yt-dlp
    z-lua
    eza
    #btop
    #tor
    #discord
    dua
    fzf
    #git
    zulu
    #nerdfonts
    #iina
    #iterm2
    #lmstudio
    nil
    nixd
    nixpkgs-fmt
    #raycast
    #rsync
    #spotify
    #stats
    #telegram-desktop
    #transmission
    #unar # The Unarchiver
    #utm
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Auto upgrade nix package and the daemon service.
  # nix.package = pkgs.nix;

  nix.nixPath = [ "nixpkgs=${nixpkgs-unstable}" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  security.sudo.extraConfig = ''
    Defaults         timestamp_timeout=30
  '';

  security.pam.enableSudoTouchIdAuth = true;

  #nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  #environment.darwinConfig = "$HOME/.config/nix-darwin";

  system.stateVersion = 4;
}
