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

        configRC = mkOption {
            description = "Vim Config (lua)";
            type = types.lines;
            default = "";
        };

        plugins = mkOption {
            description = "testing string based plugins";
            type = with types; listOf string;
            default = [];
        };
    };

    imports = [
        ./options.nix
        ./treesitter.nix
        ./telescope.nix
    ];
}
