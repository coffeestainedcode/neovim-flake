{
  description = "Neovim flake for my ideal development experience";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Treesitter
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    nvim-treesitter-textobjects = {
      url = "github:nvim-treesitter/nvim-treesitter-textobjects";
      flake = false;
    };
    nvim-treesitter-context = {
      url = "github:nvim-treesitter/nvim-treesitter-context";
      flake = false;
    };

    # Telescope
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    telescope-fzf-native = {
      url = "github:nvim-telescope/telescope-fzf-native.nvim";
      flake = false;
    };
    plenary = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    # Nvim-tree
    nvim-tree = {
      url = "github:nvim-tree/nvim-tree.lua";
      flake = false;
    };
    nvim-web-devicons = {
      url = "github:nvim-tree/nvim-web-devicons";
      flake = false;
    };

    # Languages (LSP, completion, etc)
    lsp-config = {
      url = "github:neovim/nvim-lspconfig";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    nvim-cmp-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    nvim-cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    luasnip = {
      url = "github:L3MON4D3/LuaSnip";
      flake = false;
    };
    cmp_luasnip = {
      url = "github:saadparwaiz1/cmp_luasnip";
      flake = false;
    };
    fidget = {
      url = "github:j-hui/fidget.nvim";
      flake = false;
    };
    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    lsp-signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };
    code-action-menu = {
      url = "github:weilbith/nvim-code-action-menu";
      flake = false;
    };
    lspkind = {
      url = "github:onsails/lspkind.nvim";
      flake = false;
    };

    # Misc
    gitsigns = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };
    lualine = {
      url = "github:nvim-lualine/lualine.nvim";
      flake = false;
    };
    nvim-surround = {
      url = "github:kylechui/nvim-surround";
      flake = false;
    };
    vim-sleuth = {
      url = "github:tpope/vim-sleuth";
      flake = false;
    };
    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    comment = {
      url = "github:numToStr/Comment.nvim";
      flake = false;
    };

    # Themes
    catppuccin = {
      url = "github:catppuccin/nvim";
      flake = false;
    };
    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };
    gruvbox = {
      url = "github:ellisonleao/gruvbox.nvim";
      flake = false;
    };
    onedark = {
      url = "github:navarasu/onedark.nvim";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , ...
    } @ inputs:
    let
      eachSystem = f:
        nixpkgs.lib.genAttrs [
          "aarch64-darwin"
          "aarch64-linux"
          "x86_64-darwin"
          "x86_64-linux"
        ]
          (system: f nixpkgs.legacyPackages.${system});

      neovimBuilder = import ./lib/neovimBuilder.nix;
      default-config = import ./default-config.nix;
    in
    rec {
      formatter = eachSystem (pkgs: pkgs.nixpkgs-fmt);

      # For implementing in other Nix flakes
      overlays.default = final: prev: {
        inherit neovimBuilder;
        preconfigured = packages.${prev.system}.default;
      };

      packages = eachSystem (pkgs: {
        default = neovimBuilder {
          inherit pkgs inputs;
          config.customNeovim = default-config;
        };
        empty = neovimBuilder {
          inherit pkgs inputs;
          config.customNeovim = { };
        };
      });
    };
}
