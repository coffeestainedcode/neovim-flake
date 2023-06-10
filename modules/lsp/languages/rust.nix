{ pkgs
, lib
, config
, ...
}:
with lib;
with builtins; let
  cfg = config.customNeovim.languages.rust;
in
{
  options.customNeovim.languages.rust = {
    enable = mkEnableOption "Enable rust language support";
    format = mkEnableOption "Enable formatting for rust";
  };

  config = mkIf cfg.enable {
    customNeovim.plugins.treesitter.grammars = [
      "rust"
    ];

    customNeovim.lsp.null-ls.format-commands = mkIf cfg.format [
      # INIT-LUA
      ''
        null_ls.builtins.formatting.rustfmt.with({
          command = "${pkgs.rustfmt}/bin/rustfmt",
        }),
      ''
    ];

    customNeovim.configRC = [
      {
        priority = 2;
        content =
          # INIT-LUA
          ''
            require'lspconfig'.rust_analyzer.setup{
                autostart = true,
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = {"${pkgs.rust-analyzer}/bin/rust-analyzer"},
            }
          '';
      }
    ];
  };
}
