{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.which-key;
in {
    options.customNeovim.which-key = {
        enable = mkEnableOption "Enable which-key";
    };

    config = mkIf cfg.enable {
        customNeovim.plugins = [
            "which-key"
        ];
        customNeovim.configRC = [{
            priority = 1;
            content = ''
                require('which-key').setup {
                }
            '';
        }];
    };
}
