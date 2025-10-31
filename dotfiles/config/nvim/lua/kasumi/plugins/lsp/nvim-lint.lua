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
-- WARN:  Para ver los mensajes de diagnostico, debes agregar las extensiones en nvim-lspconfig.lua
--
local lint = require("lint")

lint.linters_by_ft = {
	-- stylua: ignore start
	css      = { "stylelint" },
	json     = { "jsonlint" },
	json5    = { "deno" },
	jsonc    = { "deno" },
	lua      = { "luacheck" }, -- Debes tener instalado: luarocks
	markdown = { "markdownlint" },
	python   = { "pylint" },
	sh       = { "shellcheck" },
	sql      = { "sqlfluff" },
	yaml     = { "yamllint" },
	-- stylua: ignore end
}

-- Suprime los warnings al agregar el valor como global
lint.linters.luacheck.args = {
	"--globals",
	"vim",
}

-- Desactiva la regla MD013 (líneas demasiado largas) en markdownlint,
lint.linters.markdownlint.args = {
	"--disable",
	"MD013",
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

-- Definición de linter personalizado para JSONC usando deno_fmt
local lint = require("lint")
lint.linters.deno = {
	cmd = "deno",
	-- stdin = true,
	-- ignore_exitcode = true, -- evita que la ejecución se interrumpa por exit code
	-- stream = "stderr", -- los errores se envían a stderr
	-- stream = "stdout", -- deno fmt imprime errores en stdout
	args = {
		"-",
		"fmt",
		"--check", -- chequea formato sin modificar
	},
	-- parser = require("lint.parser").from_errorformat(
	-- 	"%f:%l:%c: %m", -- formatea: archivo:linea:columna: mensaje
	-- 	{ source = "deno" }
	-- ),
}
