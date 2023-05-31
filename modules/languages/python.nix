{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.customNeovim.languages.python;
in {
  options.customNeovim.languages.python = {
    enable = mkEnableOption "Enable python language support";
  };

  config = mkIf cfg.enable {
    customNeovim.languages.lsp.enable = true;
    customNeovim.languages.cmp.enable = true;
    customNeovim.languages.snippets.enable = true;

    customNeovim.plugins.treesitter.grammars = [
      "python"
    ];

    customNeovim.configRC = [
      {
        priority = 2;
        content = ''
          require("lspconfig").pylsp.setup{
              autostart = true,
              capabilities = capabilities,
              on_attach = on_attach,
              settings = {
                  pylsp = {
                      configurationSources = { "pycodestyle", "flake8" },
                      plugins = {
                          pycodestyle = { enabled = true },
                          flake8 = {
                              enabled = true,
                              executable = "${pkgs.python3Packages.flake8}/bin/flake8"
                          }
                      }
                  }
              },
              cmd = {"${pkgs.python311Packages.python-lsp-server}/bin/pylsp"},
          }
        '';
      }
    ];
  };
}
