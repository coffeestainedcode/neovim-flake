{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.customNeovim.lsp.null-ls;
  any-language-formatting =
    builtins.any
    (language: config.customNeovim.languages.${language}.format)
    config.customNeovim.lsp.available-languages;
in {
  options.customNeovim.lsp.null-ls = {
    enable = mkEnableOption "Enable null-ls";
    format-on-save = mkEnableOption "Format on save";
    commitlint = mkEnableOption "Enable commit lint";
    format-commands = mkOption {
      description = "INTERNAL. To define the null-ls source values";
      type = with types; listOf str;
      default = "";
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
                    ${
              if cfg.commitlint
              then ''
                null_ls.builtins.diagnostics.commitlint.with {
                  command = "${pkgs.commitlint}/bin/commitlint",
                }
              ''
              else ""
            }
                },
                ${
              if cfg.format-on-save
              then ''
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                                -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
                                vim.lsp.buf.format({ async = false })
                            end,
                        })
                    end
                end,
              ''
              else ""
            }
            })
          '';
        }
      ];
    };
}
