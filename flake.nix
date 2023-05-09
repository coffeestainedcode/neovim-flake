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

        # Surround words and whatnot with keybinds
        nvim-surround = { url = "github:kylechui/nvim-surround"; flake = false; };
        # Detect shiftwidth and tabstop automatically
        vim-sleuth = { url = "github:tpope/vim-sleuth"; flake = false; };
        # Show keybinds dynamically
        which-key = { url = "github:folke/which-key.nvim"; flake = false; };

        # Themes
        onedark-nvim = { url = "github:navarasu/onedark.nvim"; flake = false; };
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
                        treesitter.enable = true;
                        telescope.enable = true;
                        nvim-tree.enable = true;
                        which-key.enable = true;
                    };
                };
                default = customNeovim;
            };
        }
    );
}
