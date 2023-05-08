{ pkgs
, config
, inputs
}: let
    vimOptions = pkgs.lib.evalModules {
        modules = [
            { imports = [./modules]; }
            config 
        ];
        specialArgs = {
            inherit pkgs; 
        };
    };

    plugins = let
        plugins = customNeovim.plugins;
        buildPlug = name: pkgs.vimUtils.buildVimPluginFrom2Nix {
            pname = name;
            version = "master";
            src = builtins.getAttr name inputs;
        };
        in map (name: buildPlug name) plugins;
        
    # Set so I don't have to type so much
    customNeovim = vimOptions.config.customNeovim;

    in pkgs.wrapNeovim pkgs.neovim-unwrapped {
        viAlias =  customNeovim.viAlias;
        vimAlias = customNeovim.vimAlias;
        configure = {
            customRC = ''
                lua << EOF
                    ${customNeovim.configRC}
                EOF
            '';
            packages.myVimPackage = with pkgs.neovimPlugins; {
                start = plugins;
                opt = [];
            };
        };
}
