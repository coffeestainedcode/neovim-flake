# What is This?
This is my personal neovim config that I want to build out using nix.
I already have a working neovim config written in lua, but want to experiment
with the Nix package manager and dive deeper into the subject.

# Usage
At the moment, the only way I know how to run this is either:
`nix run github:SamuelSehnert/neovim-flake`
or
`nix build github:SamuelSehnert/neovim-flake` to build into a `result` directory.

## Warning:
The source code, as it stands in this repo, is for testing only.
This means that there may exist debug statments, unconfigurable options,
or preconfigured options.

# Inspiration
[Kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim)

[neovim-flake:jordanisaacs](https://github.com/jordanisaacs/neovim-flake)

[neovim-flake:wiltaylor](https://github.com/wiltaylor/neovim-flake)

[neovim-flake:Quoteme](https://github.com/Quoteme/neovim-luca)
