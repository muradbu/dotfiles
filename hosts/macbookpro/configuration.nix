{ pkgs, nixpkgs, self, ... }:

{
  nixpkgs.overlays = [
    (import ../../overlays/gemini-cli-bin)
  ];

  ids.gids.nixbld = 350;

  users.users.murad = {
    name = "murad";
    home = "/Users/murad";
  };

  environment.systemPackages = with pkgs; [
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
    libssh
    nil
    self.packages.${pkgs.stdenv.hostPlatform.system}.neovim
    nixd
    nixfmt
    nodejs_25
    sops
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

  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.settings.trusted-users = [ "root" "murad" ];

  programs.zsh.enable = true;

  security.sudo.extraConfig = ''
    Defaults         timestamp_timeout=30
  '';

  nixpkgs.config.allowUnfree = true;

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.stateVersion = 4;
}
