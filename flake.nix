{
    description = "Neovim flake for MY ideal development experience";

    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
        flake-utils.url = "github:numtide/flake-utils";

        # Plugins

        # Syntax-tree sitter
        nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
        nvim-treesitter-textobjects = { url = "github:nvim-treesitter/nvim-treesitter-textobjects"; flake = false; };

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
            pluginOverlay = final: prev: let
                inherit (prev.vimUtils) buildVimPluginFrom2Nix;
                plugins = builtins.attrNames
                    ( builtins.removeAttrs inputs
                    [ "self" "nixpkgs" "flake-utils" ] );
                buildPlug = name: buildVimPluginFrom2Nix {
                    pname = name;
                    version = "master";
                    src = builtins.getAttr name inputs;
                };
                buildTreesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins
                    # (_: config.customNeovim.treesitter.grammars);
                    (grammar : with grammar; [ ocaml zig lua ]);

                in {
                    neovimPlugins = builtins.listToAttrs (map
                        (name: {
                            name = name;
                            value = (
                                if name == "nvim-treesitter" then
                                    buildTreesitter
                                else
                                    buildPlug name);
                        })
                        plugins);
                };

            pkgs = import nixpkgs {
                inherit system;
                overlays = [
                    pluginOverlay
                ];
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
                inherit pkgs;
                config.customNeovim = {
                    treesitter.enable = true;
                    # treesitter.grammars = wi[ rust ];
                };
            };
        }
    );
}
