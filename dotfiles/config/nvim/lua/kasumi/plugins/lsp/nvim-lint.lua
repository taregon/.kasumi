-- ██╗     ██╗███╗   ██╗████████╗███████╗██████╗
-- ██║     ██║████╗  ██║╚══██╔══╝██╔════╝██╔══██╗
-- ██║     ██║██╔██╗ ██║   ██║   █████╗  ██████╔╝
-- ██║     ██║██║╚██╗██║   ██║   ██╔══╝  ██╔══██╗
-- ███████╗██║██║ ╚████║   ██║   ███████╗██║  ██║
-- ╚══════╝╚═╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝╚═╝  ╚═╝
--
-- Este plugin proporciona una interfaz para mostrar y manejar
-- los errores y advertencias producidos por los linters,
--  https://github.com/mfussenegger/nvim-lint?tab=readme-ov-file#available-linters
-- NOTA: no incluye los linters en sí mismos.
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
