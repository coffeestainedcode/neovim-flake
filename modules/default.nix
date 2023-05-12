/*
This file defines the needed configuration options
to set in other files.
Also imports all other option/plugin files
*/
{ pkgs, lib, config, ...}:
with lib;

let
    cfg = config.customNeovim;
in {
    options.customNeovim = {
        viAlias = mkOption {
            description = "Enable vi alias";
            type = types.bool;
            default = false;
        };

        vimAlias = mkOption {
            description = "Enable vim alias";
            type = types.bool;
            default = false; 
        };

        /*
            configRC exists as a listOf attrs such that
            attrs = {
                priority = int;
                content = lines;
            };
            and priority starts at highest (0) and increases.
            The point of this is to allow the RC content
            to be sorted so that certain lines occur before
            others.
            I suspect this approach may be too naive to last,
            as it currently only sorts by priority number and
            nothing else. If in the future, I wanted to define
            more complicated relations between nodes, I would
            need to implement a DAG instead.
        */
        configRC = mkOption {
            description = "Vim Config (lua)";
            type = with types; listOf attrs;
            default = [];
        };

        plugins = mkOption {
            description = "Plugins to use";
            type = with types; listOf str;
            default = [];
        };
    };

    imports = [
        # Import languages default
        ./languages

        # Import plugins
        ./comment.nix
        ./gitsigns.nix
        ./indent-blankline.nix
        ./lualine.nix
        ./options.nix
        ./nvim-surround.nix
        ./nvim-tree.nix
        ./telescope.nix
        ./theme.nix
        ./treesitter.nix
        ./whichkey.nix
        ./vim-sleuth.nix
    ];
}
