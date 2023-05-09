{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.vim-sleuth;
in {
    options.customNeovim.vim-sleuth = {
        enable = mkEnableOption "Enable vim-sleuth";
    };

    config = mkIf cfg.enable {
        customNeovim.plugins = [
            "vim-sleuth"
        ];
    };
}
