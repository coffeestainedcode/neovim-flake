{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.telescope;
in {
    options.customNeovim.telescope = {
        enable = mkEnableOption "Enable telescope";
    };

    config = mkIf cfg.enable {
        customNeovim.plugins = [
            "plenary"
            "telescope"
        ];
        customNeovim.configRC = [{
            priority = 1;
            content = ''
                require("telescope").setup {
                }
            '';
        }];
    };
}
