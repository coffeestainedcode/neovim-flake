{ pkgs
, lib
, config
, ...
}:
with lib;
with builtins; let
  cfg = config.customNeovim.languages.ocaml;
in
{
  options.customNeovim.languages.ocaml = {
    enable = mkEnableOption "Enable ocaml language support";
    format = mkEnableOption "Enable formatting for ocaml";
  };

  config = mkIf cfg.enable {
    customNeovim.plugins.treesitter.grammars = [
      "ocaml"
    ];

    customNeovim.lsp.null-ls = {
      format-commands = mkIf cfg.format [
        # INIT-LUA
        ''
          null_ls.builtins.formatting.ocamlformat.with({
            command = "${pkgs.ocamlformat}/bin/ocamlformat",
          }),
        ''
      ];
    };

    customNeovim.configRC = [
      {
        priority = 2;
        content =
          # INIT-LUA
          ''
            require("lspconfig").ocamllsp.setup{
                autostart = true,
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = {"${pkgs.ocamlPackages.ocaml-lsp}/bin/ocamllsp"},
            }
          '';
      }
    ];
  };
}
