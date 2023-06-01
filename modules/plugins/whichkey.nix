{ pkgs
, lib
, config
, ...
}:
with lib;
with builtins; let
  cfg = config.customNeovim.plugins.which-key;
in
{
  options.customNeovim.plugins.which-key = {
    enable = mkEnableOption "Enable which-key";
  };

  config = mkIf cfg.enable {
    customNeovim.installedPlugins = [
      "which-key"
    ];
    customNeovim.configRC = [
      {
        priority = 1;
        content = ''
          require('which-key').setup {
          }
        '';
      }
    ];
  };
}
