{ pkgs
, lib
, config
, ...
}:
with lib;
with builtins; let
  cfg = config.customNeovim.plugins.comment;
in
{
  options.customNeovim.plugins.comment = {
    enable = mkEnableOption "Enable comment";
  };

  config = mkIf cfg.enable {
    customNeovim.installedPlugins = [
      "comment"
    ];

    customNeovim.configRC = [
      {
        priority = 1;
        content =
          # INIT-LUA
          ''
            require('Comment').setup {}
          '';
      }
    ];
  };
}
