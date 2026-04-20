-- ┌────────────────────────────────────────────────────────────────────┐
-- │░█░░░▀█▀░█▀█░▀█▀░█▀▀░█▀▄░░░▄▀░░░░█▀▀░█▀█░█▀▄░█▄█░█▀█░▀█▀░▀█▀░█▀▀░█▀▄│
-- │░█░░░░█░░█░█░░█░░█▀▀░█▀▄░░░▄█▀░░░█▀▀░█░█░█▀▄░█░█░█▀█░░█░░░█░░█▀▀░█▀▄│
-- │░▀▀▀░▀▀▀░▀░▀░░▀░░▀▀▀░▀░▀░░░░▀▀░░░▀░░░▀▀▀░▀░▀░▀░▀░▀░▀░░▀░░░▀░░▀▀▀░▀░▀│
-- └────────────────────────────────────────────────────────────────────┘
-- NOTA: solo instala LINTERS & FORMATTER
-- Si encuentras fallas, puedes ejecutar :checkhealth mason, también :MasonLog
-- Puede que necesites instalar 'npm'
-- https://github.com/williamboman/mason.nvim/blob/main/doc/mason.txt#L50

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
		"beautysh", -- Shell
		"deno", -- JSON / TOML / Markdown
		"fixjson", -- JSON
		"prettierd", -- CSS / GraphQL / HTML / JSON / JS / TS / YAML
		"shfmt", -- Shell
		"sql-formatter", -- SQL
		"stylua", -- Lua
		"taplo", -- TOML
		"xmlformatter", -- XML
		"yamlfix", -- YAML

		-- ───────────────────────────< LSP >───────────────────────────
		-- (configurado en mason-lspconfig.lua)
	},

	auto_update = true,
	debounce_hours = 12,
	run_on_start = true,
	start_delay = 2000,

	integrations = {
		["mason-lspconfig"] = true,
		["mason-null-ls"] = false,
		["mason-nvim-dap"] = false,
	},
})
