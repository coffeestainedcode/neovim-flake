{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.languages.typescript;
in {
    options.customNeovim.languages.typescript = {
        enable = mkEnableOption "Enable typescript language support";
    };

    config = mkIf cfg.enable{
        customNeovim.languages.lsp.enable = true;
        customNeovim.languages.cmp.enable = true;
        customNeovim.languages.snippets.enable = true;
        
        customNeovim.plugins.treesitter.grammars = [
            "typescript"
        ];

        customNeovim.configRC = [{
            priority = 2;
            content = ''
                require("lspconfig").tsserver.setup {
                    autostart = true,
                    capabilities = capabilities,
                    on_attach=on_attach,
                    cmd = {"${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio"}
                }
            '';
        }];
    };
}
