---@brief
---
--- https://github.com/ocaml/ocaml-lsp
---
--- `ocaml-lsp` can be installed as described in [installation guide](https://github.com/ocaml/ocaml-lsp#installation).
---
--- To install the lsp server in a particular opam switch:
--- ```sh
--- opam install ocaml-lsp-server
--- ```

local util = require("lspconfig.util")

local language_id_of = {
	menhir = "ocaml.menhir",
	ocaml = "ocaml",
	ocamlinterface = "ocaml.interface",
	ocamllex = "ocaml.ocamllex",
	reason = "reason",
	dune = "dune",
}

local get_language_id = function(_, ftype)
	return language_id_of[ftype]
end

---Infer interface from implementation
---@param bufnr integer
---@param client vim.lsp.Client
local function infer_interface_request(bufnr, client)
	local method_name = "ocamllsp/inferIntf"

	if not client or not client:supports_method(method_name) then
		return vim.notify(
			("method %s is not supported by any servers active on the current buffer"):format(method_name)
		)
	end

	local params = { vim.lsp.util.make_text_document_params(bufnr).uri }

	---@diagnostic disable-next-line:param-type-mismatch
	client:request(method_name, params, function(err, result)
		if err then
			error(tostring(err))
		end

		if not result then
			vim.notify("corresponding file cannot be determined")
			return
		end

		local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
		if #lines == 1 and lines[1]:match("^%s*$") then
			vim.api.nvim_paste(result, false, -1)
		end
	end, bufnr)
end

---Switch between interface & implementation files (similar to switch between source header in clangd)
---@param bufnr integer
---@param client vim.lsp.Client
local function switch_implementation_interface(bufnr, client)
	local method_name = "ocamllsp/switchImplIntf"

	if not client or not client:supports_method(method_name) then
		vim.notify(("method %s is not supported by any servers active on the current buffer"):format(method_name))
		return false
	end

	local params = { vim.lsp.util.make_text_document_params(bufnr).uri }

	client:request(method_name, params, function(err, result)
		if err then
			error(tostring(err))
			return
		end

		if not result then
			vim.notify("corresponding file cannot be determined")
			return
		end

		vim.cmd.edit(vim.uri_to_fname(result[1]))
	end, bufnr)
end

---@type vim.lsp.Config
return {
	cmd = { "ocamllsp" },

	filetypes = { "ocaml", "menhir", "ocamlinterface", "ocamllex", "reason", "dune" },

	root_dir = function(bufnr, on_dir)
		local fname = vim.api.nvim_buf_get_name(bufnr)
		on_dir(util.root_pattern("*.opam", "esy.json", "package.json", ".git", "dune-project", "dune-workspace")(fname))
	end,

	get_language_id = get_language_id,

	settings = {
		extendedHover = { enable = true },
		standardHover = { enable = true },
		codelens = { enable = true },
		duneDiagnostics = { enable = true },
		inlayHints = {
			hint_pattern_variables = true,
			hint_let_bindings = true,
			hint_function_params = true,
		},
		syntaxDocumentation = { enable = true },
		merlinJumpCodeActions = { enable = true },
	},

	on_attach = function(client, bufnr)
		vim.api.nvim_buf_create_user_command(bufnr, "LspOcamlSwitchImplementationInterface", function()
			switch_implementation_interface(bufnr, client)
		end, { desc = "Switch between implementation/interface" })

		vim.api.nvim_buf_create_user_command(bufnr, "LspOcamlInferInterfaceRequest", function()
			infer_interface_request(bufnr, client)
		end, { desc = "Switch between implementation/interface" })

		vim.keymap.set("n", "<leader>ch", function()
			switch_implementation_interface(bufnr, client)
			infer_interface_request(bufnr, client)
		end, {
			desc = "switch implementation/interface (ocaml)",
		})
	end,
}
