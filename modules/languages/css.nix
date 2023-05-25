{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.languages.css;
in {
    options.customNeovim.languages.css = {
        enable = mkEnableOption "Enable css language support";
    };

    config = mkIf cfg.enable{
        customNeovim.languages.lsp.enable = true;
        customNeovim.languages.cmp.enable = true;
        customNeovim.languages.snippets.enable = true;
        
        customNeovim.plugins.treesitter.grammars = [
            "css" "scss"
        ];

        customNeovim.configRC = [{
            priority = 2;
            content = ''
                require("lspconfig").cssls.setup {
                    autostart = true,
                    capabilities = capabilities,
                    on_attach = on_attach,
                    cmd = {"${pkgs.nodePackages_latest.vscode-css-languageserver-bin}/bin/css-languageserver", "--stdio"},
                }
            '';
        }];
    };
}
