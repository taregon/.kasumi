-- ┌────────────────────────────────────────────────────────────────────┐
-- │░█░░░▀█▀░█▀█░▀█▀░█▀▀░█▀▄░░░▄▀░░░░█▀▀░█▀█░█▀▄░█▄█░█▀█░▀█▀░▀█▀░█▀▀░█▀▄│
-- │░█░░░░█░░█░█░░█░░█▀▀░█▀▄░░░▄█▀░░░█▀▀░█░█░█▀▄░█░█░█▀█░░█░░░█░░█▀▀░█▀▄│
-- │░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀░▀░░░░▀▀░░░▀░░░▀▀▀░▀░▀░▀░▀░▀░▀░░▀░░░▀░░▀▀▀░▀░▀│
-- └────────────────────────────────────────────────────────────────────┘
-- NOTA: Instala LINTERS, FORMATTER y ahora... LSP!
-- Si encuentras fallas, puedes ejecutar :checkhealth mason, también :MasonLog
-- Puede que necesites instalar 'npm'
-- https://github.com/williamboman/mason.nvim/blob/main/doc/mason.txt#L50
-- Comandos útiles: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim#commands
-- Para forzar la instalación :MasonToolsUpdate
-- Para eliminar obsoletos :MasonToolsClean

require("mason-tool-installer").setup({
	ensure_installed = {
		-- ─────────────────────────< LINTERS >─────────────────────────
		"jsonlint", -- JSON
		"luacheck", -- Lua
		"markdownlint", -- Markdown
		"ruff", -- Python
		"shellcheck", -- Shell
		"sqlfluff", -- SQL
		"yamllint", -- YAML

		-- ───────────────────────< FORMATTERS >────────────────────
		"deno", -- JSON / Markdown
		"prettierd", -- CSS / GraphQL / HTML / JSON / JSON5 / JS / TS / YAML
		"shfmt", -- Shell
		"sql-formatter", -- SQL
		"stylua", -- Lua
		"tombi", -- TOML
		"xmlformatter", -- XML
		"yamlfix", -- YAML
		"beautysh",

		-- ───────────────────────────< LSP >───────────────────────────
		-- Normalmente estaría en mason-lspconfig.lua, pero este plugin
		-- permite centralizar aquí la instalación de herramientas.
		-- mason-lspconfig se mantiene para la configuración de LSP.
		"awk-language-server", --"awk_ls",
		"bash-language-server", -- "bashls",
		"css-lsp", -- "cssls"
		"dockerfile-language-server", -- "dockerls",
		"graphql-language-service-cli", -- "graphql",
		"html-lsp", -- "html",
		"json-lsp", -- "jsonls",
		"lua-language-server", -- "lua_ls",
		"marksman",
		"sqlls",
		"ty",
		"yaml-language-server", -- "yamlls",
		-- "pyright",
	},

	auto_update = true,
	debounce_hours = 12,
	run_on_start = true,
	start_delay = 4000,

	integrations = {
		["mason-lspconfig"] = false,
		["mason-null-ls"] = false,
		["mason-nvim-dap"] = false,
	},
})
