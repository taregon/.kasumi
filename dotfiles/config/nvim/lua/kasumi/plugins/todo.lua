-- ┌────────────────────────────────────────────────────┐
-- │░▀█▀░█▀█░█▀▄░█▀█░░░░░█▀▀░█▀█░█▄█░█▄█░█▀▀░█▀█░▀█▀░█▀▀│
-- │░░█░░█░█░█░█░█░█░▄▄▄░█░░░█░█░█░█░█░█░█▀▀░█░█░░█░░▀▀█│
-- │░░▀░░▀▀▀░▀▀░░▀▀▀░░░░░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀░▀░░▀░░▀▀▀│
-- └────────────────────────────────────────────────────┘
require("todo-comments").setup({
	keywords = {
		FIX = { icon = "󰶯", color = "error", alt = { "FIXME", "BUG" } },
		NOTE = { icon = "", color = "hint", alt = { "NOTA" } },
		TODO = { icon = "󱖫", color = "info", alt = { "pendiente", "REVISAR", "PEND" } },
		WARN = { icon = "󱇏", color = "warning", alt = { "advertencia", "ADVERTENCIA" } },
	},
	highlight = {
		multiline = false, -- Si esta desactivado, solo resalta una linea.
	},
	colors = {
		-- error = "#ff747e", -- Linea de ejemplo
	},
})
