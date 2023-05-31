{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.customNeovim.languages.c;
in {
  options.customNeovim.languages.c = {
    enable = mkEnableOption "Enable c/c++ language support";
  };

  config = mkIf cfg.enable {
    customNeovim.plugins.treesitter.grammars = [
      "c"
    ];

    customNeovim.configRC = [
      {
        priority = 2;
        content = ''
          require("lspconfig").clangd.setup{
              autostart = true,
              capabilities = capabilities,
              on_attach = on_attach,
              cmd = {"${pkgs.clang-tools}/bin/clangd"},
          }
        '';
      }
    ];
  };
}
