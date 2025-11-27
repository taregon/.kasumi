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

-- ────────────────────────────────────────────────────────────
-- Auto-indentación y limpieza de archivos AWK al guardar:
-- Re-aplica GetAwkIndent() a todo el buffer
augroup("AwkIndent", function(group)
	aucmd("BufWritePre", {
		group = group,
		pattern = "*.awk",
		callback = function()
			vim.cmd("normal! gg=G")
		end,
	})
end)

-- ────────────────────────────────────────────────────────────
-- Ejecutar automáticamente los formatters configurados al guardar.
local conform = require("conform")

augroup("FormatOnSave", function(group)
	aucmd("BufWritePre", {
		group = group,
		pattern = "*",
		callback = function(args)
			conform.format({ bufnr = args.buf })
		end,
	})
end)

-- Alterna números relativos según el modo:
-- activa relativos en Normal, los desactiva en Insert y en cualquier modo Visual.
augroup("ToggleRelativeNumber", function(group)
	-- Al abrir buffer → relativos por defecto
	aucmd({ "BufEnter", "BufWinEnter" }, {
		group = group,
		callback = function()
			vim.opt.number = true
			vim.opt.relativenumber = true
		end,
	})

	-- Insert → desactiva relativos
	aucmd("InsertEnter", {
		group = group,
		callback = function()
			vim.opt.relativenumber = false
		end,
	})

	-- Normal → activa relativos
	aucmd("InsertLeave", {
		group = group,
		callback = function()
			vim.opt.relativenumber = true
		end,
	})

	-- Visual modes → desactiva relativos
	aucmd("ModeChanged", {
		group = group,
		pattern = "*:[vV]*", -- cualquier transición hacia v, V o Ctrl-v
		callback = function()
			vim.opt.relativenumber = false
		end,
	})

	-- Salir de Visual → reactiva relativos
	aucmd("ModeChanged", {
		group = group,
		pattern = "[vV]*:*", -- cualquier transición desde modos Visual
		callback = function()
			-- Solo reactiva si no estamos en Insert
			if vim.fn.mode():match("i") then
				return
			end
			vim.opt.relativenumber = true
		end,
	})
end)
