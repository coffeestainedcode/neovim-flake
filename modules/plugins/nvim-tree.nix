{ pkgs
, lib
, config
, ...
}:
with lib;
with builtins; let
  cfg = config.customNeovim.plugins.nvim-tree;
in
{
  options.customNeovim.plugins.nvim-tree = {
    enable = mkEnableOption "Enable nvim-tree";
  };

  config = mkIf cfg.enable {
    customNeovim.installedPlugins = [
      "nvim-tree"
      "nvim-web-devicons"
    ];
    customNeovim.configRC = [
      {
        priority = 1;
        content = ''
          require('nvim-tree').setup {
          }
          vim.api.nvim_set_keymap('n', '<leader>t', ':NvimTreeToggle<CR>', {noremap = true, silent = true})
        '';
      }
    ];
  };
}
