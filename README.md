# nvim-config

[![wakatime](https://wakatime.com/badge/user/452b0d4c-9951-457d-868a-2007cd651d66/project/fa13f39d-8ba5-40f3-a120-60b0ad4d0c27.svg)](https://wakatime.com/badge/user/452b0d4c-9951-457d-868a-2007cd651d66/project/fa13f39d-8ba5-40f3-a120-60b0ad4d0c27)
Neovim config

## Install Instructions

Open this config with nix:

```sh
nix run github:RisGar/nvim-config
```

Or use it as an input for your flake:

```nix
inputs = {
    nvim-config = {
      url = "github:RisGar/nvim-config";
      inputs.nixpkgs.follows = "nixpkgs";
    };
};
```
