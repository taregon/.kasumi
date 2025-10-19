-- ┌──────────────────────────────────────┐
-- │░█░░░█▀▀░█▀█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀│
-- │░█░░░▀▀█░█▀▀░░░█░░░█░█░█░█░█▀▀░░█░░█░█│
-- │░▀▀▀░▀▀▀░▀░░░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀│
-- └──────────────────────────────────────┘

local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

-- ─[ BASH ]─────────────────────────────────────────────────
vim.lsp.config["bashls"] = {
	filetypes = { "sh" },
	capabilities = lsp_capabilities,
}
vim.lsp.enable("bashls")

-- ─[ Docker ]───────────────────────────────────────────────
vim.lsp.config["dockerls"] = {
	filetypes = { "dockerfile" },
	capabilities = lsp_capabilities,
}
vim.lsp.enable("dockerls")

-- ─[ GraphQL ]──────────────────────────────────────────────
vim.lsp.config["graphql"] = {
	filetypes = { "graphql" },
	capabilities = lsp_capabilities,
}
vim.lsp.enable("graphql")

-- ─[ HTML ]─────────────────────────────────────────────────
vim.lsp.config["html"] = {
	filetypes = { "html" },
	capabilities = lsp_capabilities,
}
vim.lsp.enable("html")

-- ─[ JSON ]─────────────────────────────────────────────────
vim.lsp.config["jsonls"] = {
	filetypes = { "json" },
	capabilities = lsp_capabilities,
}
vim.lsp.enable("jsonls")

-- Python
vim.lsp.config["pyright"] = {
	filetypes = { "python" },
	capabilities = lsp_capabilities,
}
vim.lsp.enable("pyright")

-- YAML
vim.lsp.config["yamlls"] = {
	filetypes = { "yaml" },
	capabilities = lsp_capabilities,
	settings = {
		yaml = {
			schemas = {
				kubernetes = "*.yaml",
			},
		},
	},
}
vim.lsp.enable("yamlls")

-- Lua
vim.lsp.config["lua_ls"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
	capabilities = lsp_capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- library = vim.api.nvim_get_runtime_file("", true), -- Esta linea eleva el CPU
				library = { [vim.fn.stdpath("config")] = true }, -- limita el diagnostico a ~/.config/nvim/
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
vim.lsp.enable("lua_ls")
