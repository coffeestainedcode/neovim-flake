{ pkgs, lib, config, ...}:
with lib;
with builtins;

let
    cfg = config.customNeovim.options;
in
{
    options.customNeovim.options = {
        mapleader = mkOption {
            description = "Key to use for the map leader";
            type = types.str;
            default = " ";
        };

        wrap = mkOption {
            description = "When on, lines longer than the width of the window will wrap and displaying continues on the next line.";
            type = types.bool;
            default = false;
        };

        scrolloff = mkOption {
            description = "Minimal number of screen lines to keep above and below the cursor.";
            type = types.int;
            default = 8;
        };

        hlsearch = mkOption {
            description = "When there is a previous search pattern, highlight all its matches.";
            type = types.bool;
            default = false;
        };

        number = mkOption {
            description = "Print the line number in front of each line.";
            type = types.bool;
            default = true;
        };

        relativenumber = mkOption {
            description = "Show the line number relative to the line with the cursor in front of each line.";
            type = types.bool;
            default = true;
        };

        mouse = mkOption {
            description = "Enables mouse support";
            type = with types; enum [ "" "a" "n" "v" "i" "c" ];
            default = "";
        };

        clipboard = mkOption {
            description = "Enable vim to interact with system clipboard";
            type = with types; enum [ "" "unnamed" "unnamedplus" ];
            default = "";
        };

        breakindent = mkOption {
            description = "Every wrapped line will continue visually indented (same amount of space as the beginning of that line), thus preserving horizontal blocks of text.";
            type = types.bool;
            default = true;
        };

        undofile = mkOption {
            description = "When on, Vim automatically saves undo history to an undo file when writing a buffer to a file, and restores undo history from the same file on buffer read.";
            type = types.bool;
            default = true;
        };

        ignorecase = mkOption {
            description = "Ignore case in search patterns.  Also used when searching in the tags file.";
            type = types.bool;
            default = true;
        };

        smartcase = mkOption {
            description = "Override the 'ignorecase' option if the search pattern contains upper case characters. Only used when the search pattern is typed and 'ignorecase' option is on.";
            type = types.bool;
            default = true;
        };

        signcolumn = mkOption {
            description = "When and how to draw the signcolumn.";
            type = with types; enum [ "auto" "no" "yes" ];
            default = "yes";
        };

        updatetime = mkOption {
            description = "If this many milliseconds nothing is typed the swap file will be written to disk.";
            type = types.int;
            default = 250;
        };

        timeout = mkOption {
            description = "This option and 'timeoutlen' determine the behavior when part of a mapped key sequence has been received.";
            type = types.bool;
            default = true;
        };

        timeoutlen = mkOption {
            description = "Time in milliseconds to wait for a mapped sequence to complete.";
            type = types.int;
            default = 300;
        };

        completeopt = mkOption {
            description = "A comma-separated list of options for Insert mode completion.";
            type = with types; listOf str;
            default = ["menuone" "noselect"];
        };

        termguicolors = mkOption {
            description = "Enables 24-bit RGB color in the TUI.";
            type = types.bool;
            default = true;
        };

        highlightOnYank = mkOption {
            description = "Highlight on yank";
            type = types.bool;
            default = true;
        };
    };

    config = {
        customNeovim.configRC = [{
            priority = 0;
            content = ''
                vim.g.mapleader = '${cfg.mapleader}'
                vim.g.maplocalleader = '${cfg.mapleader}'
                vim.o.wrap = ${boolToString cfg.wrap}
                vim.o.scrolloff = ${toString cfg.scrolloff}
                vim.o.hlsearch = ${boolToString cfg.hlsearch}
                vim.wo.number = ${boolToString cfg.number}
                vim.wo.relativenumber = ${boolToString cfg.relativenumber}
                vim.o.mouse = '${cfg.mouse}'
                vim.o.clipboard = '${cfg.clipboard}'
                vim.o.breakindent = ${boolToString cfg.breakindent}
                vim.o.undofile = ${boolToString cfg.undofile}
                vim.o.ignorecase = ${boolToString cfg.ignorecase}
                vim.o.smartcase = ${boolToString cfg.smartcase}
                vim.wo.signcolumn = '${cfg.signcolumn}'
                vim.o.updatetime = ${toString cfg.updatetime}
                vim.o.timeout = ${boolToString cfg.timeout}
                vim.o.timeoutlen = ${toString cfg.timeoutlen}
                vim.o.completeopt = ${builtins.concatStringsSep "," cfg.completeopt}
                vim.o.termguicolors = ${boolToString cfg.termguicolors}
                ${if cfg.highlightOnYank then ''
                    local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
                    vim.api.nvim_create_autocmd('TextYankPost', {
                        callback = function()
                            vim.highlight.on_yank()
                        end,
                        group = highlight_group,
                        pattern = '*',
                    })
                '' else ""}
            '';
        }];
    };
}
