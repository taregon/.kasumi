-- Simplifica la llamada al método de creación de auto comandos
local aucmd = vim.api.nvim_create_autocmd

-- Función para crear y configurar grupos de auto comandos
-- name: nombre del grupo de autocomandos
-- fn: función que define los autocomandos dentro del grupo
local function augroup(name, fn)
	local group = vim.api.nvim_create_augroup(name, { clear = true })
	fn(group)
end

-- Activa el coloreado para archivos INI
augroup("Ini_Files", function(group)
	aucmd("BufReadPost", {
		group = group,
		pattern = "*.conf",
		command = "set syntax=dosini",
	})
end)

-- Ejecuta linters automáticamente
augroup("NvimLint", function(group)
	aucmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
		group = group,
		callback = function()
			require("lint").try_lint()
		end,
	})
end)

-- Ruecuerda la ultima posición del cursor
local function last_position()
	local last_line = vim.fn.line("'\"")
	if last_line > 1 and last_line <= vim.fn.line("$") then
		vim.cmd('normal! g`"')
	end
end

augroup("RestoreCursor", function(group)
	aucmd("BufReadPost", {
		group = group,
		pattern = "*",
		callback = last_position,
	})
end)

-- Colorea los CSV
augroup("CsvFileTypes", function(group)
	aucmd({ "BufNewFile", "BufRead" }, {
		group = group,
		pattern = "*.csv",
		command = "set filetype=rfc_csv",
	})
	aucmd({ "BufNewFile", "BufRead" }, {
		group = group,
		pattern = "*.dat",
		command = "set filetype=csv_pipe",
	})
end)
