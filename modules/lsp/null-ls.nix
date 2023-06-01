{ pkgs
, lib
, config
, ...
}:
with lib; let
  cfg = config.customNeovim.lsp.null-ls;
  any-language-formatting =
    builtins.any
      (language: config.customNeovim.languages.${language}.format)
      config.customNeovim.lsp.available-languages;
in
{
  options.customNeovim.lsp.null-ls = {
    enable = mkEnableOption "Enable null-ls";
    commitlint = mkEnableOption "Enable commit lint";
    format-commands = mkOption {
      description = "INTERNAL: To define the null-ls formatting source values";
      type = with types; listOf str;
      default = [ ];
    };
    diagnostic-commands = mkOption {
      description = "INTERNAL: To define the null-ls diagnostic values";
      type = with types; listOf str;
      default = [ ];
    };
  };

  config = mkIf (cfg.enable || any-language-formatting) {
    customNeovim.installedPlugins = [
      "null-ls"
    ];

    customNeovim.configRC = [
      {
        priority = 1;
        content = ''
          local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
          local null_ls = require("null-ls")
          null_ls.setup({
              default_timeout = 5000,
              sources = {
                  ${toString (builtins.map (_:_) config.customNeovim.lsp.null-ls.format-commands)}
                  ${toString (builtins.map (_:_) config.customNeovim.lsp.null-ls.diagnostic-commands)}
              },
          })
        '';
      }
    ];
  };
}
