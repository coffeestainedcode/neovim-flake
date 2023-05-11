{
    description = "Neovim flake for MY ideal development experience";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        flake-utils.url = "github:numtide/flake-utils";

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

    outputs = { self, nixpkgs, flake-utils, ... }@inputs:
        flake-utils.lib.eachDefaultSystem (system: let
            pkgs = import nixpkgs {
                inherit system;
            };
            neovimBuilder = (import ./lib/neovimBuilder.nix);
        in rec {
            apps.${system} = rec {
                nvim = {
                    type = "app";
                    program = "${packages.default}/bin/nvim";
                };
                default = nvim;
            };

            packages = rec {
                customNeovim = neovimBuilder {
                    inherit pkgs inputs;
                    config.customNeovim = {
                        comment.enable = true;
                        gitsigns.enable = true;
                        indent-blankline.enable = true;
                        lualine.enable = true;
                        treesitter.enable = true;
                        telescope.enable = true;
                        nvim-tree.enable = true;
                        which-key.enable = true;
                        vim-sleuth.enable = true;
                        nvim-surround.enable = true;
                        theme = {
                            catppuccin = {
                                enable = true;
                                setOnStartup = false;
                                style = "latte";
                            };
                            tokyonight = {
                                enable = true;
                                setOnStartup = true;
                                style = "storm";
                            };
                            gruvbox = {
                                enable = true;
                                setOnStartup = false;
                                style = "light";
                            };
                            onedark = {
                                enable = true;
                                setOnStartup = false;
                                style = "dark";
                            };
                        };
                    };
                };
                default = customNeovim;
            };
        }
    );
}
