# nvim-config

[![wakatime](https://wakatime.com/badge/user/452b0d4c-9951-457d-868a-2007cd651d66/project/fa13f39d-8ba5-40f3-a120-60b0ad4d0c27.svg)](https://wakatime.com/badge/user/452b0d4c-9951-457d-868a-2007cd651d66/project/fa13f39d-8ba5-40f3-a120-60b0ad4d0c27)

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

## Plugins

- [xzbdmw/colorful-menu.nvim](https://github.com/xzbdmw/colorful-menu.nvim)
- [olimorris/onedarkpro.nvim](https://github.com/olimorris/onedarkpro.nvim)
- [folke/todo-comments.nvim](https://github.com/folke/todo-comments.nvim)
- [folke/ts-comments.nvim](https://github.com/folke/ts-comments.nvim)
- [folke/trouble.nvim](https://github.com/folke/trouble.nvim)
- [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs)
- [echasnovski/mini.ai](https://github.com/echasnovski/mini.ai)
- [folke/snacks.nvim](https://github.com/folke/snacks.nvim)
- [nvim-treesitter/nvim-treesitter-context](https://github.com/nvim-treesitter/nvim-treesitter-context)
- [HiPhish/rainbow-delimiters.nvim](https://github.com/HiPhish/rainbow-delimiters.nvim)
- [stevearc/oil.nvim](https://github.com/stevearc/oil.nvim)
- [stevearc/conform.nvim](https://github.com/stevearc/conform.nvim)
- [ThePrimeagen/vim-be-good](https://github.com/ThePrimeagen/vim-be-good)
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [nvim-tree/nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons)
- [folke/which-key.nvim](https://github.com/folke/which-key.nvim)
- [mrcjkb/rustaceanvim](https://github.com/mrcjkb/rustaceanvim)
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [mfussenegger/nvim-lint](https://github.com/mfussenegger/nvim-lint)
- [j-hui/fidget.nvim](https://github.com/j-hui/fidget.nvim)
- [mfussenegger/nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls)
- [b0o/SchemaStore.nvim](https://github.com/b0o/SchemaStore.nvim)
- [MeanderingProgrammer/render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
- [tris203/precognition.nvim](https://github.com/tris203/precognition.nvim)
- [folke/lazydev.nvim](https://github.com/folke/lazydev.nvim)
- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim)
- [chomosuke/typst-preview.nvim](https://github.com/chomosuke/typst-preview.nvim)
- [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets)
- [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip)
- [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim)
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [echasnovski/mini.surround](https://github.com/echasnovski/mini.surround)
- [lervag/vimtex: VimTeX](https://github.com/lervag/vimtex)

## Language Servers

- astro
- bashls
- clangd
- cssls
- eslint
- gleam
- html
- jdtls
- jsonls
- julials
- lua_ls
- marksman
- nixd
- ocamllsp
- rust_analyzer
- svelte
- taplo
- texlab
- vtsls
- yamlls
