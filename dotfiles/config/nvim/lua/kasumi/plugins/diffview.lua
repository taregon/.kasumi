-- ┌────────────────────────────────┐
-- │░█▀▄░▀█▀░█▀▀░█▀▀░█░█░▀█▀░█▀▀░█░█│
-- │░█░█░░█░░█▀▀░█▀▀░▀▄▀░░█░░█▀▀░█▄█│
-- │░▀▀░░▀▀▀░▀░░░▀░░░░▀░░▀▀▀░▀▀▀░▀░▀│
-- └────────────────────────────────┘
local diffview = require("diffview")

diffview.setup({
	enhanced_diff_hl = true,
	use_icons = true,
	icons = {
		folder_closed = "",
		folder_open = "",
	},
})

-- Función para habilitar el panel
local diffview_open = false
local prev_cwd = vim.fn.getcwd() -- Guarda el directorio original

local toggle_diffview = function()
	if diffview_open then
		diffview.close()
		vim.cmd("lcd " .. prev_cwd) -- 👈 restaura el directorio original
		diffview_open = false
	else
		local file_real = vim.fn.resolve(vim.fn.expand("%:p")) -- sigue symlink
		local file_dir = vim.fn.fnamemodify(file_real, ":h")
		local git_root = vim.fn.systemlist("git -C " .. file_dir .. " rev-parse --show-toplevel")[1]

		if git_root and vim.fn.isdirectory(git_root .. "/.git") == 1 then
			prev_cwd = vim.fn.getcwd() -- guarda cwd actual
			vim.cmd("lcd " .. git_root)

			local relative_path = vim.fn.fnamemodify(file_real, ":.") -- ruta relativa al repo
			vim.cmd("DiffviewOpen origin/main -- " .. relative_path) -- Abre comparación contra origin/main (estable)
			vim.cmd("DiffviewToggleFiles") -- Cierra el panel automáticamente
			-- vim.cmd("wincmd r") -- Invierte las vistas
			diffview_open = true
		else
			vim.notify("El archivo no pertenece a un repositorio Git.", vim.log.levels.WARN)
		end
	end
end

-- Atajo para activar la función
vim.keymap.set("n", "<F5>", toggle_diffview, { noremap = true, silent = true })
