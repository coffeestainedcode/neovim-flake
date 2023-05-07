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

        startupPlugins = mkOption {
            description = "Plugins to load on start";
            type = with types; listOf (nullOr package);
            default = [];
        };

        optionalPlugins = mkOption {
            description = "Plugins to be optionally loaded";
            type = with types; listOf (nullOr package);
            default = [];
        };
    };

    imports = [
        ./options.nix
        ./treesitter.nix
    ];
}
