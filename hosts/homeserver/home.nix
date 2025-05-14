{ config, ... }:

{
  #home.packages = with pkgs; [ ];

  programs.bash.profileExtra = ''
    if command -v fzf-share >/dev/null; then
      source "$(fzf-share)/key-bindings.bash"
      source "$(fzf-share)/completion.bash"
    fi

    eval "$(/run/current-system/sw/bin/z --init bash fzf)"
  '';

  home.stateVersion = "24.11";
}
