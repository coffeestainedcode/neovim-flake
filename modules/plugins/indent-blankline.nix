{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.customNeovim.plugins.indent-blankline;
in {
  options.customNeovim.plugins.indent-blankline = {
    enable = mkEnableOption "Enable indent-blankline";
  };

  config = mkIf cfg.enable {
    customNeovim.installedPlugins = [
      "indent-blankline"
    ];

    customNeovim.configRC = [
      {
        priority = 1;
        content = ''
          require('indent_blankline').setup {
              char = '┊',
              show_trailing_blankline_indent = false,
          }
        '';
      }
    ];
  };
}
