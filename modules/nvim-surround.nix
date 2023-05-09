{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.nvim-surround;
in {
    options.customNeovim.nvim-surround = {
        enable = mkEnableOption "Enable vim-surround";
    };

    config = mkIf cfg.enable {
        customNeovim.plugins = [
            "nvim-surround"
        ];
        customNeovim.configRC = [{
            priority = 1;
            content = ''
                require('nvim-surround').setup {
                }
            '';
        }];
    };
}
