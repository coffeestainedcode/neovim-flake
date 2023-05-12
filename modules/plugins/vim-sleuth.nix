{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.plugins.vim-sleuth;
in {
    options.customNeovim.plugins.vim-sleuth = {
        enable = mkEnableOption "Enable vim-sleuth";
    };

    config = mkIf cfg.enable {
        customNeovim.installedPlugins = [
            "vim-sleuth"
        ];
    };
}
