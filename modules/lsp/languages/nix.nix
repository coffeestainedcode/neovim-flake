{ pkgs
, lib
, config
, ...
}:
with lib;
with builtins; let
  cfg = config.customNeovim.languages.nix;
in
{
  options.customNeovim.languages.nix = {
    enable = mkEnableOption "Enable nix language support";
    format = mkEnableOption "Enable formatting for nix";
  };

  config = mkIf cfg.enable {
    customNeovim.plugins.treesitter.grammars = [
      "nix"
    ];

    customNeovim.lsp.null-ls.format-commands = mkIf cfg.format [
      ''
        null_ls.builtins.formatting.nixpkgs_fmt.with({
          command = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt",
        }),
      ''
    ];

    customNeovim.configRC = [
      {
        priority = 2;
        content = ''
          require("lspconfig").nil_ls.setup{
              autostart = true,
              capabilities = capabilities,
              on_attach = on_attach,
              cmd = {"${pkgs.nil}/bin/nil"},
          }
        '';
      }
    ];
  };
}
