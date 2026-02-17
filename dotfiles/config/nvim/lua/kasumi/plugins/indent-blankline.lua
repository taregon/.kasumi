-- ┌──────────────────────────────────────┐
-- │░▀█▀░█▀▄░█░░░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀│
-- │░░█░░█▀▄░█░░░░░█░░░█░█░█░█░█▀▀░░█░░█░█│
-- │░▀▀▀░▀▀░░▀▀▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀│
-- └──────────────────────────────────────┘
-- Lineas de sangría
-- La animación la gestiona mini.indentscope

require("ibl").setup({
	indent = {
		-- La linea vertical faltante esta en mini.lua
		char = "│", -- para indicar espacios
		tab_char = "╎", -- para indicar tabs. Sino, saldrían flechas
	},
	scope = {
		char = "▎", -- más gruesa o distinta
	},
	exclude = {
		filetypes = {
			"conf",
			"git",
			"markdown",
			"startify",
			"text",
		},
		buftypes = {
			"checkhealth",
			"comment-box",
			"grug-far",
			"neo-tree",
			"nofile",
			"quickfix",
			"codecompanion",
		},
	},
})
