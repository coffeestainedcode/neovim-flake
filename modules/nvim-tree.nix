{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.nvim-tree;
in {
    options.customNeovim.nvim-tree = {
        enable = mkEnableOption "Enable nvim-tree";
    };

    config = mkIf cfg.enable {
        customNeovim.plugins = [
            "nvim-tree"
            "nvim-web-devicons"
        ];
        customNeovim.configRC = [{
            priority = 1;
            content = ''
                require('nvim-tree').setup {
                }
                vim.api.nvim_set_keymap('n', '<leader>t', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
            '';
        }];
    };
}
