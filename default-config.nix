{
    plugins = {
        comment.enable = true;
        gitsigns.enable = true;
        indent-blankline.enable = true;
        lualine.enable = true;
        treesitter.enable = true;
        telescope.enable = true;
        nvim-tree.enable = true;
        which-key.enable = true;
        vim-sleuth.enable = true;
        nvim-surround.enable = true;
    };
    languages = {
        c.enable = true;
        nix.enable = true;
        python.enable = true;
        rust.enable = true;
        typescript.enable = true;
    };
    theme = {
        catppuccin = {
            enable = true;
            setOnStartup = false;
            style = "latte";
        };
        tokyonight = {
            enable = true;
            setOnStartup = true;
            style = "storm";
        };
        gruvbox = {
            enable = true;
            setOnStartup = false;
            style = "light";
        };
        onedark = {
            enable = true;
            setOnStartup = false;
            style = "dark";
        };
    };
}
