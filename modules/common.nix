# Cross-platform base shared by NixOS hosts (via hosts/shared.nix) and the
# nix-darwin host. Only options that exist in both module systems belong here.
{
  pkgs,
  self,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    bat
    btop
    curl
    eza
    git
    tmux
    wget
    self.packages.${pkgs.stdenv.hostPlatform.system}.neovim
    yazi
  ];

  environment.shellAliases = {
    cat = "bat";
    dps = "docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'";
    ls = "eza -lghHbm --git --icons --time-style=long-iso --group-directories-first";

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

  environment.variables.EDITOR = "nvim";

  security.sudo.extraConfig = ''
    Defaults:murad          timestamp_timeout=30
  '';
}
