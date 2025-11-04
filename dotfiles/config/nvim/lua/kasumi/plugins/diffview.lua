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

local toggle_diffview = function()
	if diffview_open then
		diffview.close()
		diffview_open = false
	else
		diffview.open()
		vim.cmd("DiffviewToggleFiles") -- Cierra el panel automáticamente
		-- vim.cmd("wincmd r") -- Invierte las vistas
		diffview_open = true
	end
end

-- Atajo para activar la función
vim.keymap.set("n", "<F5>", toggle_diffview, { noremap = true, silent = true })
