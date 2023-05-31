{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.customNeovim.plugins.gitsigns;
in {
  options.customNeovim.plugins.gitsigns = {
    enable = mkEnableOption "Enable gitsigns";
  };

  config = mkIf cfg.enable {
    customNeovim.installedPlugins = [
      "gitsigns"
    ];

    customNeovim.configRC = [
      {
        priority = 1;
        content = ''
          require('gitsigns').setup {
              signs = {
                  add = { text = '+' },
                  change = { text = '~' },
                  delete = { text = '_' },
                  topdelete = { text = '‾' },
                  changedelete = { text = '~' },
              },
              current_line_blame = true,
          }
        '';
      }
    ];
  };
}
