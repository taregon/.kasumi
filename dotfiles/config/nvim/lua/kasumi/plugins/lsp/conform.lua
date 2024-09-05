--    ____                    __  __
--   / __/__  ______ _  ___ _/ /_/ /____ ____
--  / _// _ \/ __/  ' \/ _ `/ __/ __/ -_) __/
-- /_/  \___/_/ /_/_/_/\_,_/\__/\__/\__/_/
--
-- Lista de opciones
-- https://github.com/stevearc/conform.nvim/blob/master/doc/conform.txt
-- Formatters
-- https://github.com/stevearc/conform.nvim#formatters
-- Ver informe de errores
-- :ConformInfo

require("conform").setup({
	formatters = {
		sql_formatter = {
			args = { "--config", vim.fn.expand("~/.config/nvim/lua/kasumi/goodies/sql-formatter.json") },
		},
		yamlfix = {
			env = { YAMLFIX_SEQUENCE_STYLE = "block_style" }, -- Por defecto viene con: low-style list: [item, item]
		},
		shfmt = { -- https://github.com/mvdan/sh/blob/master/cmd/shfmt/shfmt.1.scd
			args = { "-i", "4", "-ci", "-bn", "-sr" },
		},
	},
	formatters_by_ft = {
        -- stylua: ignore start
		["*"]    = { "squeeze_blanks", "trim_newlines", "trim_whitespace" },
		graphql  = { "prettierd" },
		json     = { "deno_fmt" },
		lua      = { "stylua" },
		markdown = { "deno_fmt" },
		python   = { "isort", "black" },
		sh       = { "shfmt" },
		sql      = { "sql_formatter" }, -- https://github.com/sql-formatter-org/sql-formatter/blob/master/docs/language.md
		yaml     = { "yamlfix" },
		-- stylua: ignore end
	},
	format_on_save = {
		timeout_ms = 3000,
		-- lsp_format = "fallback",
	},
})
