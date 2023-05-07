{ pkgs
, config
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
                start = customNeovim.startupPlugins;
                opt = [];
            };
        };
}
