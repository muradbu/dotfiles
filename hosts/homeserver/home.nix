{ pkgs, config, ... }:

{
  home.username = "murad";
  home.homeDirectory = "/home/murad";

  home.packages = with pkgs; [
    htop
  ];

  programs.bash.enable = true;
  programs.bash.profileExtra = ''
    if command -v fzf-share >/dev/null; then
      source "$(fzf-share)/key-bindings.bash"
      source "$(fzf-share)/completion.bash"
    fi

    eval "$(/run/current-system/sw/bin/z --init bash fzf)"
  '';

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
