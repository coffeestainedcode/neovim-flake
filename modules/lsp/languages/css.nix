{ pkgs
, lib
, config
, ...
}:
with lib;
with builtins; let
  cfg = config.customNeovim.languages.css;
in
{
  options.customNeovim.languages.css = {
    enable = mkEnableOption "Enable css language support";
    format = mkEnableOption "Enable formatting for css";
  };

  config = mkIf cfg.enable {
    customNeovim.plugins.treesitter.grammars = [
      "css"
      "scss"
    ];

    customNeovim.lsp.null-ls.format-commands = mkIf cfg.format [
      ''
        null_ls.builtins.formatting.prettier.with({
          command = "${pkgs.nodePackages_latest.prettier}/bin/prettier",
        }),
      ''
    ];

    customNeovim.configRC = [
      {
        priority = 2;
        content = ''
          require("lspconfig").cssls.setup {
              autostart = true,
              capabilities = capabilities,
              on_attach = on_attach,
              cmd = {"${pkgs.nodePackages_latest.vscode-css-languageserver-bin}/bin/css-languageserver", "--stdio"},
          }
        '';
      }
    ];
  };
}
