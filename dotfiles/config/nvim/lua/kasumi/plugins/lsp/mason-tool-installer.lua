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
		-- ───────────────────────< Shell / Zsh >──────────────────
		"beautysh", -- Formateador para scripts shell, pero en mi caso: ZSH
		"shellcheck", -- Linter para shell
		"shfmt", -- Formateador y parser para bash/sh

		-- ─────────────────────────< Python >─────────────────────
		"black", -- Formateador
		"isort", -- Ordena imports
		"pylint", -- Linter

		-- ──────────────────────────< JSON >──────────────────────
		"deno", -- Formateador: JSON, JSONC
		"fixjson", -- Formateador para JSON5
		"jsonlint", -- Linter para JSON

		-- ─────────────────────< Multipropósito >─────────────────
		"prettierd", -- Formateador: CSS, GRAPHQL, HTML,

		-- Lua
		"luacheck", -- Linter
		"stylua", -- Formateador

		-- ────────────────────────< Markdown >────────────────────
		"markdownlint", -- Linter
		"mdformat", -- Formateador

		-- ───────────────────────────< SQL >──────────────────────
		"sql-formatter", -- Formateador
		"sqlfluff", -- Linter

		-- ──────────────────────────< TOML >──────────────────────
		"taplo", -- Formateador

		-- ──────────────────────────< YAML >──────────────────────
		"yamlfix", -- Formateador que conserva comentarios
		"yamllint", -- Linter
	},
	run_on_start = true,
	auto_update = true,
})
