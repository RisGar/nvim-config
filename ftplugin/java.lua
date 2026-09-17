vim.cmd.packadd("nvim-jdtls")

-- eclipse.jdt.ls extensions ("bundles") that add debugging support.
-- `java-debug` provides the DAP adapter and the ability to resolve a main
-- class and its runtime classpath. The jar is provided by the Nix wrapper,
-- see `vim.g.java_debug_jar_dir` in default.nix.
--
-- The bundles are only read when the server starts, so run `:LspRestart`
-- after changing this file.
local bundles = {}
if vim.g.java_debug_jar_dir then
  bundles = vim.fn.glob(vim.g.java_debug_jar_dir .. "/*.jar", false, true)
end

-- See `:help vim.lsp.start` for an overview of the supported `config` options.
local config = {
  name = "jdtls",

  -- `cmd` defines the executable to launch eclipse.jdt.ls.
  -- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
  --
  -- As alternative you could also avoid the `jdtls` wrapper and launch
  -- eclipse.jdt.ls via the `java` executable
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = { "jdtls" },

  -- `root_dir` must point to the root of your project.
  -- See `:help vim.fs.root`
  root_dir = vim.fs.root(0, { "gradlew", ".git", "mvnw" }),

  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      configuration = {
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- And search for `interface RuntimeOption`
        -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
        runtimes = {
          {
            name = "JavaSE-17",
            path = vim.g.jdks["java-17"],
          },
          {
            name = "JavaSE-21",
            path = vim.g.jdks["java-21"],
          },
          {
            name = "JavaSE-25",
            path = vim.g.jdks["java-25"],
          },
        },
      },
    },
  },

  -- This sets the `initializationOptions` sent to the language server
  -- If you plan on using additional eclipse.jdt.ls plugins like java-debug
  -- you'll need to set the `bundles`
  --
  -- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
  init_options = {
    bundles = bundles,
  },
}
require("jdtls").start_or_attach(config)

-- Register the `java` adapter with nvim-dap and enable main class discovery.
-- See https://codeberg.org/mfussenegger/nvim-dap/wiki/Java
-- The `dap.configurations.java` entries live in plugin/debug.lua
require("jdtls").setup_dap({ hotcodereplace = "auto" })
