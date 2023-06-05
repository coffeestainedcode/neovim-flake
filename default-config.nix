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
  lsp.null-ls = {
    enable = true;
  };
  languages = {
    c = {
      enable = true;
      format = true;
      diagnostic = true;
    };
    css = {
      enable = true;
      format = true;
    };
    nix = {
      enable = true;
      format = true;
    };
    python = {
      enable = true;
      format = true;
    };
    rust = {
      enable = true;
      format = true;
    };
    typescript = {
      enable = true;
      format = true;
    };
    ocaml = {
      enable = true;
      format = true;
    };
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
