{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.options;
in
{
    options.customNeovim.options = {
        mouse = mkOption {
            description = "Enable Mouse";
            type = with types; enum ["a" "n" "v" "i" "c" ""];
            default = "";
        };
    };

    config = {
        customNeovim.configRC = ''
            vim.wo.number = true
        '';
    };
}
