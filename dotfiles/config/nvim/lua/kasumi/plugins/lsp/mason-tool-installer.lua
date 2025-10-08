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
		"beautysh", -- zsh formatter
		"black", -- python formatter
		"deno", -- markdown, javascript, typescript, json formatter
		"fixjson", -- json5
		"isort", -- python formatter
		"jsonlint", -- json linter
		"luacheck", -- lua linter
		"markdownlint", -- Markdown
		"prettierd", -- GraphQL
		"pylint", -- python linter
		"shellcheck", -- shell linter
		"shfmt", -- A shell parser, formatter, and interpreter with bash support.
		"sql-formatter",
		"sqlfluff", -- The SQL Linter for Humans
		"stylua", -- lua formatter
		"taplo", -- TOML
		"yamlfix", -- YAML formatter that keeps comments.
		"yamllint", -- YAML linter
	},
	run_on_start = true,
	auto_update = true,
})
