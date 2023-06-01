{
  pkgs,
  lib,
  config,
  ...
}:
with lib;
with builtins; let
  cfg = config.customNeovim.theme;
in {
  options.customNeovim.theme = let
    mkThemeOptions = name: styles: default-style: {
      enable = mkEnableOption "Enable ${name} theme.";
      setOnStartup = mkEnableOption "Enable ${name} to autostart. Only works if enable is true.";
      style = mkOption {
        description = "Style to be applied to theme on startup. Only works if enable and setOnStartup are true.";
        type = with types; enum styles;
        default = default-style;
      };
    };
  in {
    catppuccin = mkThemeOptions "catppuccin" ["latte" "frappe" "macchiato" "mocha"] "mocha";
    tokyonight = mkThemeOptions "tokyonight" ["night" "storm" "day" "moon"] "night";
    gruvbox = mkThemeOptions "gruvbox" ["dark" "light"] "dark";
    onedark = mkThemeOptions "onedark" ["dark" "darker" "cool" "deep" "warm" "warmer" "light"] "dark";
  };

  config = {
    customNeovim.installedPlugins = [
      (
        if (cfg.catppuccin.enable)
        then "catppuccin"
        else ""
      )
      (
        if (cfg.tokyonight.enable)
        then "tokyonight"
        else ""
      )
      (
        if (cfg.gruvbox.enable)
        then "gruvbox"
        else ""
      )
      (
        if (cfg.onedark.enable)
        then "onedark"
        else ""
      )
    ];

    customNeovim.configRC = let
      /*
      This function checks if multiple theme config have setOnStartup true;
            Returns 1 if valid con and 0 if invalid
      */
      checkMultipleStartup = attrSet: let
        createArr = attrSet: map (n: n.setOnStartup) (builtins.attrValues attrSet);
        length = builtins.length (pkgs.lib.remove false (createArr attrSet));
      in
        length == 0 || length == 1;

      /*
      Checks if setOnStartup is true while enable is false.
           Returns 1 if valid and of if invalid
      */
      checkStartWithoutEnableValidity = attrSet:
        !(builtins.any (n: !(n.enable || !n.setOnStartup)) (builtins.attrValues attrSet));

      assertionA = checkMultipleStartup cfg;
      assertionB = checkStartWithoutEnableValidity cfg;
    in
      assert (assertionA && assertionB)
      || abort
      ''        Error in setting themes.
                    Check that only one setOnStartup is true AND
                    if setOnStartup is true for any theme, enable is also true.''; [
        {
          priority = 0; # Priority of 0 as it won't cause problems wth mapleader
          content = ''
            ${
              if cfg.catppuccin.setOnStartup
              then "vim.cmd.colorscheme 'catppuccin-${cfg.catppuccin.style}'"
              else ""
            }
            ${
              if cfg.tokyonight.setOnStartup
              then "vim.cmd.colorscheme 'tokyonight-${cfg.tokyonight.style}'"
              else ""
            }
            ${
              if cfg.gruvbox.setOnStartup
              then ''
                vim.o.background = "${cfg.gruvbox.style}"
                vim.cmd.colorscheme 'gruvbox'
              ''
              else ""
            }
            ${
              if cfg.onedark.setOnStartup
              then ''
                require('onedark').setup {
                    style = '${cfg.onedark.style}'
                }
                require('onedark').load()
              ''
              else ""
            }
          '';
        }
      ];
  };
}
