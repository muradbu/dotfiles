{
  pkgs,
  nixpkgs,
  self,
  ...
}:

{
  imports = [
    ../../modules/common.nix
  ];

  ids.gids.nixbld = 350;

  users.users.murad = {
    name = "murad";
    home = "/Users/murad";
  };

  environment.systemPackages = with pkgs; [
    age
    gemini-cli-bin
    dua
    fswatch
    fzf
    git-crypt
    inetutils
    gh
    libssh
    nil
    nixd
    nixfmt
    nodejs_latest
    sops
    zoxide
    zulu
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  nix.nixPath = [ "nixpkgs=${nixpkgs}" ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [
    "root"
    "murad"
  ];

  programs.zsh.enable = true;
  programs.zsh.interactiveShellInit = ''
    eval "$(zoxide init zsh)"
  '';

  nixpkgs.config.allowUnfree = true;

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.stateVersion = 4;
}
