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

  tex = pkgs.texliveMinimal.withPackages (
    ps: with ps; [
      latex-bin
      latexmk
    ]
  );

  # Runtime dependencies that will be added to PATH
  extraPackages = with pkgs; [
    # LSPs & Formatters
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
    tex

    # Snacks.image
    mermaid-cli
    tectonic
    imagemagick
    ghostscript

    # Snacks.picker
    git
    ripgrep
    fd

    vscode-extensions.vadimcn.vscode-lldb.adapter # For rust debugging
    tree-sitter # For nvim-treesitter
  ];

  plugins = with vimPlugins; [
    # debugging
    nvim-dap
    nvim-dap-ui
    nvim-dap-virtual-text

    # Startup plugins
    rustaceanvim
    crates-nvim
    blink-cmp
    clangd_extensions-nvim
    colorful-menu-nvim
    comment-nvim
    conform-nvim
    fidget-nvim
    friendly-snippets
    gitsigns-nvim
    lazydev-nvim
    lualine-nvim
    luasnip
    mini-ai
    mini-surround
    nvim-autopairs
    nvim-highlight-colors
    nvim-jdtls
    nvim-lint
    nvim-lspconfig
    nvim-treesitter-context
    nvim-treesitter-textobjects
    nvim-treesitter.withAllGrammars
    nvim-web-devicons
    oil-nvim
    onedarkpro-nvim
    precognition-nvim
    rainbow-delimiters-nvim
    render-markdown-nvim
    SchemaStore-nvim
    snacks-nvim
    telescope-nvim
    todo-comments-nvim
    ts-comments-nvim
    typst-preview-nvim
    vim-be-good
    vim-dadbod
    vim-dadbod-completion
    vim-dadbod-ui
    vim-wakatime
    vimtex
    which-key-nvim

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
    vscode-cpptools = "${pkgs.vscode-extensions.ms-vscode.cpptools}/share/vcode/extensions/ms-vscode.cpptools/debugAdapters/bin/OpenDebugAD7";
    vscode-js-debug = "${pkgs.vscode-js-debug}/bin/js-debug";
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
    vim.g.vscode_cpptools = "${extraPaths.vscode-cpptools}"
    vim.g.vscode_js_debug = "${extraPaths.vscode-js-debug}"
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
