-- ███████╗ ██████╗ ██████╗ ███╗   ███╗ █████╗ ████████╗████████╗███████╗██████╗
-- ██╔════╝██╔═══██╗██╔══██╗████╗ ████║██╔══██╗╚══██╔══╝╚══██╔══╝██╔════╝██╔══██╗
-- █████╗  ██║   ██║██████╔╝██╔████╔██║███████║   ██║      ██║   █████╗  ██████╔╝
-- ██╔══╝  ██║   ██║██╔══██╗██║╚██╔╝██║██╔══██║   ██║      ██║   ██╔══╝  ██╔══██╗
-- ██║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║██║  ██║   ██║      ██║   ███████╗██║  ██║
-- ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚══════╝╚═╝  ╚═╝
--
-- Lista de opciones: https://github.com/stevearc/conform.nvim/blob/master/doc/conform.txt
-- Formatters: https://github.com/stevearc/conform.nvim#formatters
-- Ver informe de errores `:ConformInfo`
-- NOTA: Deseas agregar mas, recuerda colocarlos en mason-tool-installer.lua
-- Este plug no instala, solo invoca su ejecución, aunque ciertos como
-- `trim_newlines` vienen configurados y solo se llaman.
--
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
		deno_fmt = {
			args = { "fmt", "--ext", "jsonc", "-" },
			stdin = true,
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
		jsonc    = { "deno_fmt" },
		lua      = { "stylua" },
		markdown = { "mdformat" },
		python   = { "isort", "black" },
		sh       = { "shfmt" },
		sql      = { "sql_formatter" }, -- https://github.com/sql-formatter-org/sql-formatter/blob/master/docs/language.md
		toml     = { "taplo" },
		yaml     = { "yamlfix" },
		zsh      = { "beautysh" }, --
		-- stylua: ignore end
	},
	default_format_opts = {
		lsp_format = "fallback",
		timeout_ms = 5000, -- Tiempo máximo para esperar el formateo (en ms)
	},
	-- NOTA: Como el orden afecta, pasé estas lineas a una función en el archivo de autocmd
	-- format_on_save = {
	-- 	lsp_format = "fallback", -- Estrategia: usar LSP si está disponible; si no, recurrir a Conform
	-- },
})
