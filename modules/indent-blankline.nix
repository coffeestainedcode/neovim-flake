{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.indent-blankline;
in {
    options.customNeovim.indent-blankline = {
        enable = mkEnableOption "Enable indent-blankline";
    };

    config = mkIf cfg.enable {
        customNeovim.plugins = [
            "indent-blankline"
        ];

        customNeovim.configRC = [{
            priority = 1;
            content = ''
                require('indent_blankline').setup {
                    char = '┊',
                    show_trailing_blankline_indent = false,
                }
            '';
        }];
    };
}
