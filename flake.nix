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
        plenary = { url = "github:nvim-lua/plenary.nvim"; flake = false; };

        # LSP

        # Autocomplete

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
            neovimBuilder = (import ./neovimBuilder.nix);
        in rec {
            apps.${system}.default = apps.nvim;
            packages.default = packages.customNeovim;

            apps.nvim = {
                type = "app";
                program = "${packages.default}/bin/nvim";
            };

            packages.customNeovim = neovimBuilder {
                inherit pkgs inputs;
                config.customNeovim = {
                    treesitter.enable = true;
                    telescope.enable = true;
                };
            };
        }
    );
}
