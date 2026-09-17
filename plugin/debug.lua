local dap, dapui = require("dap"), require("dapui")

-- C(PP)

dap.adapters.cppdbg = {
  id = "cppdbg",
  type = "executable",
  command = vim.g.vscode_cpptools,
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "cppdbg",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopAtEntry = true,
  },
}

dap.configurations.c = dap.configurations.cpp

-- Rust
-- Configured through rustaceanvim

-- Java
-- The `java` adapter is registered by `require('jdtls').setup_dap()` in
-- ftplugin/java.lua, see https://codeberg.org/mfussenegger/nvim-dap/wiki/Java
--
-- Main classes discovered by eclipse.jdt.ls are added on demand by nvim-jdtls,
-- so `:DapNew` also lists every `main` function of the project.
dap.configurations.java = {
  {
    type = "java",
    request = "launch",
    name = "Launch Main",
    -- `mainClass`, `projectName`, `classPaths`, `modulePaths` and `javaExec`
    -- are resolved from the current buffer by nvim-jdtls if they're missing.
    -- Set them explicitly to launch a program that isn't the current file:
    -- mainClass = "your.package.name.MainClassName",
    -- projectName = "yourProjectName",
    -- classPaths = {},
    -- modulePaths = {},
    -- javaExec = "/path/to/your/bin/java",
    -- Output (stdout/stderr) goes to dapui's REPL pane because the program
    -- runs in java-debug's internal console. Switch to "integratedTerminal"
    -- if the program reads from stdin.
    console = "internalConsole",
  },
  {
    type = "java",
    request = "attach",
    name = "Debug (Attach) - Remote",
    hostName = "127.0.0.1",
    port = 5005,
  },
}

-- JS/TS
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = vim.g.vscode_js_debug,
    args = { "${port}" },
  },
}

dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    cwd = "${workspaceFolder}",
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach",
    processId = require("dap.utils").pick_process,
    cwd = "${workspaceFolder}",
  },
}

dap.configurations.typescript = dap.configurations.javascript

-- DAP UI

dapui.setup()

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
-- The UI is not closed automatically when a session ends: a short lived
-- program (`main` that prints and exits) would otherwise open and close the
-- layout within a second and the output in the `[dap-terminal]` buffer would
-- be hidden again. Close it manually with `<leader>du` when done.

vim.keymap.set("n", "<leader>du", function()
  require("dapui").toggle({})
end, { desc = "dap ui" })
vim.keymap.set({ "n", "x" }, "<leader>de", function()
  require("dapui").eval()
end, { desc = "dap eval" })
