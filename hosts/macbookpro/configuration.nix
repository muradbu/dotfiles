{ pkgs, nixpkgs, self, ... }:

{
  nixpkgs.overlays = [
    (import ../../overlays/gemini-cli-bin)
  ];

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
    #discord
    libssh
    #git
    #iina
    #lmstudio
    #prismlauncher
    #raycast
    #rsync
    #spotify
    #stats
    #steam
    #transmission
    #ums
    #utm
    age
    gemini-cli-bin
    alejandra
    bat
    btop
    dua
    eza
    fswatch
    fzf
    git-crypt
    inetutils
    nil
    nixd
    nixfmt
    sops
    yt-dlp
    z-lua
    zulu
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

  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.trusted-users = [ "root" "murad" ];

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true; # default shell on catalina
  # programs.fish.enable = true;

  security.sudo.extraConfig = ''
    Defaults         timestamp_timeout=30
  '';

  #nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  #environment.darwinConfig = "$HOME/.config/nix-darwin";

  system.stateVersion = 4;
}
