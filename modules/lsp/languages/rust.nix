{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.customNeovim.languages.rust;
in {
  options.customNeovim.languages.rust = {
    enable = mkEnableOption "Enable rust language support";
  };

  config = mkIf cfg.enable {
    customNeovim.plugins.treesitter.grammars = [
      "rust"
    ];

    customNeovim.configRC = [
      {
        priority = 2;
        content = ''
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
