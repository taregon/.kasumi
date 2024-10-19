--    ____                    __  __
--   / __/__  ______ _  ___ _/ /_/ /____ ____
--  / _// _ \/ __/  ' \/ _ `/ __/ __/ -_) __/
-- /_/  \___/_/ /_/_/_/\_,_/\__/\__/\__/_/
--
-- Lista de opciones: https://github.com/stevearc/conform.nvim/blob/master/doc/conform.txt
-- Formatters: https://github.com/stevearc/conform.nvim#formatters
-- Ver informe de errores `:ConformInfo`
-- Deseas agregar mas, recuerda colocarlos en mason-tool-installer.lua
-- Este plug no instala, solo invoca su ejecución, aunque ciertos como
-- `trim_newlines` vienen configurados y solo se llaman.

require("conform").setup({
	formatters = {
		sql_formatter = {
			args = { "--config", vim.fn.expand("~/.config/nvim/lua/kasumi/goodies/sql-formatter.json") },
		},
		yamlfix = {
			env = {
				YAMLFIX_SEQUENCE_STYLE = "block_style",
				YAMLFIX_WHITELINES = "1",
				YAMLFIX_LINE_LENGTH = "120",
			}, -- Por defecto viene con: low-style list: [item, item]
		},
		shfmt = { -- https://github.com/mvdan/sh/blob/master/cmd/shfmt/shfmt.1.scd
			args = { "-i", "4", "-ci", "-bn", "-sr" },
		},
		awk = {
			args = { "-f", vim.fn.expand("~/.config/nvim/lua/kasumi/goodies/format.awk") },
		},
	},
	formatters_by_ft = {
		-- stylua: ignore start
		["*"]    = { "trim_whitespace", "trim_newlines", "squeeze_blanks" }, -- El orden si importa
		conf     = { "awk" },
		css      = { "prettierd" },
		graphql  = { "prettierd" },
		html     = { "prettierd" },
		json     = { "deno_fmt" },
		json5    = { "fixjson" },
		lua      = { "stylua" },
		markdown = { "deno_fmt" },
		python   = { "isort", "black" },
		sh       = { "shfmt" },
		sql      = { "sql_formatter" }, -- https://github.com/sql-formatter-org/sql-formatter/blob/master/docs/language.md
		toml     = { "taplo" },
		yaml     = { "yamlfix" },
		-- stylua: ignore end
	},
	format_on_save = {
		timeout_ms = 3000,
		lsp_format = "fallback",
	},
})
