{
    description = "Neovim flake for MY ideal development experience";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

        # Treesitter
        nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
        nvim-treesitter-textobjects = { url = "github:nvim-treesitter/nvim-treesitter-textobjects"; flake = false; };

        # Telescope
        telescope = { url = "github:nvim-telescope/telescope.nvim"; flake = false; };
        telescope-fzf-native = { url = "github:nvim-telescope/telescope-fzf-native.nvim"; flake = false; };
        plenary = { url = "github:nvim-lua/plenary.nvim"; flake = false; };

        # Nvim-tree
        nvim-tree = { url = "github:nvim-tree/nvim-tree.lua"; flake = false; };
        nvim-web-devicons = { url = "github:nvim-tree/nvim-web-devicons"; flake = false; };

        # Languages (LSP, completion, etc)
        lsp-config = { url = "github:neovim/nvim-lspconfig"; flake = false; };
        nvim-cmp = { url = "github:hrsh7th/nvim-cmp"; flake = false; };
        nvim-cmp-lsp = { url = "github:hrsh7th/cmp-nvim-lsp"; flake = false; };
        luasnip = { url = "github:L3MON4D3/LuaSnip"; flake = false; };
        cmp_luasnip = { url = "github:saadparwaiz1/cmp_luasnip"; flake = false; };
        fidget = { url = "github:j-hui/fidget.nvim"; flake = false; };

        # Misc
        gitsigns = { url = "github:lewis6991/gitsigns.nvim"; flake = false; };
        lualine = { url = "github:nvim-lualine/lualine.nvim"; flake = false; };
        nvim-surround = { url = "github:kylechui/nvim-surround"; flake = false; };
        vim-sleuth = { url = "github:tpope/vim-sleuth"; flake = false; };
        which-key = { url = "github:folke/which-key.nvim"; flake = false; };
        indent-blankline = { url = "github:lukas-reineke/indent-blankline.nvim"; flake = false; };
        comment = { url = "github:numToStr/Comment.nvim"; flake = false; };

        # Themes
        catppuccin = { url = "github:catppuccin/nvim"; flake = false; };
        tokyonight = { url = "github:folke/tokyonight.nvim"; flake = false; };
        gruvbox = { url = "github:ellisonleao/gruvbox.nvim"; flake = false; };
        onedark = { url = "github:navarasu/onedark.nvim"; flake = false; };
    };

    outputs = { self, nixpkgs, ... }@inputs: let
        systems = [
            "aarch64-darwin"
            "aarch64-linux"
            "x86_64-darwin"
            "x86_64-linux"
        ];
        forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

        genPkgs = system: import nixpkgs {
            inherit system;
        };

        neovimBuilder = (import ./lib/neovimBuilder.nix);
        default-config = (import ./default-config.nix);
    in rec {
        # For implementing in other Nix flakes
        overlays.default = final: prev: {
            inherit neovimBuilder;
            preconfigured = packages.${prev.system}.default;
        };

        apps = forAllSystems (system: {
            default = {
                type = "app";
                program = "${packages.${system}.default}/bin/nvim";
            };
        });

        packages = forAllSystems (system: let
            pkgs = genPkgs system;
        in {
            default = neovimBuilder {
                inherit pkgs inputs;
                config.customNeovim = default-config;
            };
        });
    };
}
