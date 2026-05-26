{
  lib,
  neovim-unwrapped,
  pkgs,
  vimPlugins,
  vimUtils,
  wrapNeovimUnstable,
  jdks ? [ ],
}:
let

  # Runtime dependencies that will be added to PATH
  extraPackages = with pkgs; [
    astro-language-server
    statix
    bash-language-server
    biome
    clang-tools
    docker-language-server
    fish-lsp
    gleam
    jdt-language-server
    lua-language-server
    markdownlint-cli2
    marksman
    nixd
    nixfmt
    ocamlPackages.ocaml-lsp
    ocamlPackages.ocamlformat
    prettierd
    ruff
    stylua
    svelte-language-server
    tailwindcss-language-server
    taplo
    texlab
    tinymist
    ty
    vscode-langservers-extracted
    vtsls
    yaml-language-server
    dune
    rust-analyzer
    oxlint
    mermaid-cli
    git
  ];

  plugins = with vimPlugins; [
    # Startup plugins
    comment-nvim
    nvim-highlight-colors
    SchemaStore-nvim
    blink-cmp
    clangd_extensions-nvim
    colorful-menu-nvim
    conform-nvim
    friendly-snippets
    gitsigns-nvim
    lazydev-nvim
    luasnip
    mini-ai
    mini-surround
    nvim-autopairs
    nvim-lint
    nvim-lspconfig
    nvim-treesitter.withAllGrammars
    nvim-treesitter-context
    nvim-treesitter-textobjects
    nvim-web-devicons
    oil-nvim
    onedarkpro-nvim
    precognition-nvim
    rainbow-delimiters-nvim
    render-markdown-nvim
    snacks-nvim
    todo-comments-nvim
    ts-comments-nvim
    typst-preview-nvim
    vim-be-good
    vim-dadbod
    vim-dadbod-completion
    vim-dadbod-ui
    vim-wakatime
    which-key-nvim
    telescope-nvim
    nvim-jdtls
    vimtex

    # Local config as a plugin
    neovim-config
  ];

  # Local config plugin
  neovim-config = vimUtils.buildVimPlugin {
    name = "neovim-config";
    src = ./.;
    doCheck = false;
  };

  # Extra paths for plugins
  extraPaths = {
    astro-ts-plugin = "${pkgs.astro-language-server}/lib/node_modules/astro-language-server/packages/language-tools/ts-plugin";
    svelte-ts-plugin = "${pkgs.svelte-language-server}/lib/node_modules/svelte-language-server/packages/typescript-plugin";
    typescript-sdk = "${pkgs.typescript}/lib/node_modules/typescript/lib";
  };

  # JDK paths for jdtls
  jdkPaths = lib.listToAttrs (
    map (jdk: lib.nameValuePair "java-${lib.versions.major jdk.version}" "${jdk.outPath}") jdks
  );

  luaRcContent = ''
    vim.g.astro_ts_plugin_path = "${extraPaths.astro-ts-plugin}"
    vim.g.svelte_ts_plugin_path = "${extraPaths.svelte-ts-plugin}"
    vim.g.typescript_sdk_path = "${extraPaths.typescript-sdk}"
    vim.g.jdks = vim.json.decode('${builtins.toJSON jdkPaths}')
    ${lib.readFile ./init.lua}
  '';

  wrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath extraPackages)
  ];
in

# Final wrapped Neovim package
wrapNeovimUnstable neovim-unwrapped {
  autoconfigure = true;
  autowrapRuntimeDeps = true;
  wrapRc = true;
  inherit
    luaRcContent
    wrapperArgs
    plugins
    ;
}
