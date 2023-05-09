{ pkgs
, config
, inputs
}: let
    # Constructs the configuration via options
    vimOptions = pkgs.lib.evalModules {
        modules = [
            { imports = [./modules]; }
            config 
        ];
        specialArgs = {
            inherit pkgs; 
        };
    };

    # Builds all plugins needed given the config
    plugins = let
        buildPlug = name: pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = name;
            version = "master";
            src = builtins.getAttr name inputs;
        };
        buildTreesitter = let
            # Using the name of the grammar, find the package with the path using the $default
            # https://teu5us.github.io/nix-lib.html#lib.options.mkpackageoption
            mkGrammarOption = pkgs: grammar:
                pkgs.lib.mkPackageOption pkgs ["${grammar} treesitter"] {
                    default = ["vimPlugins" "nvim-treesitter" "builtGrammars" grammar];
                };
            grammarPackages = map
                (name: (mkGrammarOption pkgs name).default)
                vimOptions.config.customNeovim.treesitter.grammars;
        in pkgs.vimPlugins.nvim-treesitter.withPlugins (_: grammarPackages);
    in map
        (name: (if name == "nvim-treesitter" then buildTreesitter else buildPlug name))
        vimOptions.config.customNeovim.plugins;
        
in pkgs.wrapNeovim pkgs.neovim-unwrapped {
    viAlias =  vimOptions.config.customNeovim.viAlias;
    vimAlias = vimOptions.config.customNeovim.vimAlias;
    configure = {
        customRC = ''
            lua << EOF
                ${vimOptions.config.customNeovim.configRC}
            EOF
        '';
        packages.myVimPackage = {
            start = plugins;
            opt = [];
        };
    };
}
