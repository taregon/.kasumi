--  █████╗ ██╗   ██╗████████╗ ██████╗  ██████╗███╗   ███╗██████╗
-- ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝████╗ ████║██╔══██╗
-- ███████║██║   ██║   ██║   ██║   ██║██║     ██╔████╔██║██║  ██║
-- ██╔══██║██║   ██║   ██║   ██║   ██║██║     ██║╚██╔╝██║██║  ██║
-- ██║  ██║╚██████╔╝   ██║   ╚██████╔╝╚██████╗██║ ╚═╝ ██║██████╔╝
-- ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝  ╚═════╝╚═╝     ╚═╝╚═════╝

-- Simplifica la llamada al método de creación de auto comandos
local aucmd = vim.api.nvim_create_autocmd

-- Función para crear y configurar grupos de auto comandos
-- @param name string nombre del grupo de autocomandos
-- @param fn function función que define los autocomandos dentro del grupo
local function augroup(name, fn)
	local group = vim.api.nvim_create_augroup(name, { clear = true })
	fn(group)
end
-- ────────────────────────────────────────────────────────────
-- Configuración de archivos INI
augroup("Ini_Files", function(group)
	-- Activa el coloreado para archivos INI y de configuración
	aucmd("BufReadPost", {
		group = group,
		pattern = { "*.conf", "*.ini" },
		command = "set syntax=dosini",
	})
end)
-- ────────────────────────────────────────────────────────────
-- Ejecuta linters automáticamente
augroup("NvimLint", function(group)
	-- Eventos optimizados para el linter
	aucmd({ "BufEnter", "BufWritePost", "TextChanged" }, {
		group = group,
		callback = function()
			require("lint").try_lint()
		end,
	})
end)
-- ────────────────────────────────────────────────────────────
-- Recuerda la última posición del cursor
local function restore_cursor_position()
	local last_line = vim.fn.line("'\"")
	if last_line > 1 and last_line <= vim.fn.line("$") then
		vim.cmd('normal! g`"')
	end
end

-- Configuración de restauración de cursor
augroup("RestoreCursor", function(group)
	aucmd("BufReadPost", {
		group = group,
		pattern = "*",
		callback = restore_cursor_position,
	})
end)
-- ────────────────────────────────────────────────────────────
-- Configuración de archivos CSV y DAT
augroup("CsvFileTypes", function(group)
	-- Manejo de archivos CSV
	aucmd({ "BufNewFile", "BufRead" }, {
		group = group,
		pattern = "*.csv",
		command = "set filetype=rfc_csv",
	})

	-- Manejo de archivos DAT
	aucmd({ "BufNewFile", "BufRead" }, {
		group = group,
		pattern = "*.dat",
		command = "set filetype=csv_pipe",
	})
end)
