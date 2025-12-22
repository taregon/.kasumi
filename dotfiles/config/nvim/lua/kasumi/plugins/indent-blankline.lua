-- ┌──────────────────────────────────────┐
-- │░▀█▀░█▀▄░█░░░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀│
-- │░░█░░█▀▄░█░░░░░█░░░█░█░█░█░█▀▀░░█░░█░█│
-- │░▀▀▀░▀▀░░▀▀▀░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀│
-- └──────────────────────────────────────┘
-- Lineas de sangría

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
			"checkhealth",
			"comment-box",
			"dashboard",
			"git",
			"help",
			"man",
			"markdown",
			"neo-tree",
			"startify",
			"terminal",
			"text",
			"conf",
		},
		buftypes = {
			"nofile",
			"prompt",
			"quickfix",
			"terminal",
		},
	},
})
