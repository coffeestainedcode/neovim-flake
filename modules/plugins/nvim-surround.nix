{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.nvim-surround;
in {
    options.customNeovim.plugins.nvim-surround = {
        enable = mkEnableOption "Enable vim-surround";
    };

    config = mkIf cfg.enable {
        customNeovim.installedPlugins = [
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
