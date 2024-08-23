--    __   _      __
--   / /  (_)__  / /____ ____
--  / /__/ / _ \/ __/ -_) __/
-- /____/_/_//_/\__/\__/_/
--
-- Este plugin proporciona una interfaz para mostrar y manejar
-- los errores y advertencias producidos por los linters,
-- pero no incluye los linters en sí mismos.
-- https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters

require("lint").linters_by_ft = {
	lua = { "luacheck" }, -- Debes tener instalado: luarocks
	markdown = { "markdownlint" },
	python = { "pylint" },
	sh = { "shellcheck" },
	sql = { "sqlfluff" },
	yaml = { "yamllint" },
}

-- Configuración de `luacheck` para reconocer variables globales en Neovim
-- require("lint").linters.luacheck = {
-- 	cmd = "luacheck",
-- 	stdin = true,
-- 	args = { -- Evita que salten mensajes de warning.
-- 		"--globals",
-- 		"vim",
-- 		"lvim",
-- 		"reload",
-- 		"plain",
-- 	},
-- 	stream = "stderr",
-- 	ignore_exitcode = true,
-- 	parser = require("lint.parser").from_errorformat("%tarning: %f:%l:%c: %m, %f:%l:%c: %m", {
-- 		source = "luacheck",
-- 	}),
-- }

-- https://docs.sqlfluff.com/en/stable/cli.html#cmdoption-sqlfluff-lint-t
-- https://docs.sqlfluff.com/en/stable/rules.html#rule-aliasing.table
--
config = function()
	local sqlfluff = require("lint").linters.sqlfluff
	sqlfluff.args = {
		"-–dialect",
		"postgres",
		"--exclude-rules",
		"LT01",
		"--",
	}
end
