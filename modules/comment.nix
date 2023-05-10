{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.comment;
in {
    options.customNeovim.comment = {
        enable = mkEnableOption "Enable comment";
    };

    config = mkIf cfg.enable {
        customNeovim.plugins = [
            "comment"
        ];

        customNeovim.configRC = [{
            priority = 1;
            content = ''
                require('Comment').setup {
                }
            '';
        }];
    };
}
