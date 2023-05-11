{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.lualine;
in {
    options.customNeovim.lualine = {
        enable = mkEnableOption "Enable lualine";
    };

    config = mkIf cfg.enable {
        customNeovim.plugins = [
            "lualine"
        ];

        customNeovim.configRC = [{
            priority = 1;
            content = ''
                require('lualine').setup {
                    options = {
                        icons_enabled = false,
                        theme = 'auto',
                        component_separators = '|',
                        section_separators = "",
                    },
                }
            '';
        }];
    };
}
