{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    colorschemes.ayu.enable = true;
    plugins = {
      nix.enable = true;
      lualine.enable = true;
      numbertoggle.enable = true;
      treesitter = {
        enable = true;
	settings = {
          highlight.enable = true;
	};
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          preselect = "cmp.PreselectMode.Item";
          mapping = {
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
      };
      lsp = {
        enable = true;
        servers.nixd.enable = true;
        servers.ts_ls.enable = true;
        servers.bashls.enable = true;
      };
    };
  };

  users.users.murad = {
    name = "murad";
    home = "/Users/murad";
  };

  home-manager.users.murad = { pkgs, ... }: {
    home.packages = [];

    home.stateVersion = "24.05";
  };

  environment.systemPackages = with pkgs; [ 
      #prismlauncher
      #steam
      #ums
      #btop
      #tor
      #discord
      #dua
      fzf
      #git
      zulu
      nerdfonts
      #iina
      #iterm2
      #lmstudio
      #neovim
      #nixd
      #nixpkgs-fmt
      #raycast
      #rsync
      #spotify
      #stats
      #telegram-desktop
      #transmission
      #unar # The Unarchiver
      #utm
    ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  security.sudo.extraConfig = ''
    Defaults         timestamp_timeout=30
  '';

  environment.shellAliases = {
    dps = "docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}'";
  };

  #nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.config.allowUnfree = true;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nix-darwin";

  system.stateVersion = 4;
}
