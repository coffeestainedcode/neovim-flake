{ pkgs
, lib
, config
, ...
}:
with lib;
with builtins; let
  cfg = config.customNeovim.languages.typescript;
in
{
  options.customNeovim.languages.typescript = {
    enable = mkEnableOption "Enable typescript language support";
    format = mkEnableOption "Enable formatting for typescript/javascript";
  };

  config = mkIf cfg.enable {
    customNeovim.plugins.treesitter.grammars = [
      "typescript"
    ];

    customNeovim.lsp.null-ls.format-commands = mkIf cfg.format [
      # INIT-LUA
      ''
        null_ls.builtins.formatting.prettier.with({
          command = "${pkgs.nodePackages_latest.prettier}/bin/prettier",
        }),
      ''
    ];

    customNeovim.configRC = [
      {
        priority = 2;
        content =
          # INIT-LUA
          ''
            require("lspconfig").tsserver.setup {
                autostart = true,
                capabilities = capabilities,
                on_attach=on_attach,
                cmd = {"${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio"}
            }
          '';
      }
    ];
  };
}
