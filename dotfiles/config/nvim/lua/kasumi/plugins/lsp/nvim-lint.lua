--    __   _      __
--   / /  (_)__  / /____ ____
--  / /__/ / _ \/ __/ -_) __/
-- /____/_/_//_/\__/\__/_/
--
-- Este plugin proporciona una interfaz para mostrar y manejar
-- los errores y advertencias producidos por los linters,
-- pero no incluye los linters en sí mismos.
-- https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters
-- Los linters que puedes utilizar son los que dispone :Mason
-- Si ocupas uno, recuerda agregar su instalación en: mason-tool-installer
--
require("lint").linters_by_ft = {
	json = { "jsonlint" },
	lua = { "luacheck" }, -- Debes tener instalado: luarocks
	markdown = { "markdownlint" },
	python = { "pylint" },
	sh = { "shellcheck" },
	sql = { "sqlfluff" },
	yaml = { "yamllint" },
}

-- Suprime los warnings al agregar el valor como global
local luacheck = require("lint").linters.luacheck
luacheck.args = {
	"--globals",
	"vim",
}

-- https://docs.sqlfluff.com/en/stable/reference/cli.html
-- https://docs.sqlfluff.com/en/stable/rules.html#rule-aliasing.table
--
local sqlfluff = require("lint").linters.sqlfluff
sqlfluff.args = {
	-- "lint",
	-- "--format=json",
	-- "-–dialect=postgres",
	-- "--exclude-rules=LT01",
	-- "-",
}
