{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./comment.nix
    ./gitsigns.nix
    ./indent-blankline.nix
    ./lualine.nix
    ./nvim-surround.nix
    ./nvim-tree.nix
    ./telescope.nix
    ./treesitter.nix
    ./whichkey.nix
    ./vim-sleuth.nix
  ];
}
