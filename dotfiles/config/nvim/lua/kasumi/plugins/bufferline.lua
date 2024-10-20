-- Para ver mas ajustes
-- :h bufferline-configuration
--
local macchiato = require("catppuccin.palettes").get_palette("macchiato")

require("bufferline").setup({
	highlights = require("catppuccin.groups.integrations.bufferline").get({
		-- styles = { "italic" },
		custom = {
			macchiato = {
				buffer_selected = {
					bg = macchiato.surface0,
					bold = true,
				},
				close_button_selected = {
					bg = macchiato.surface0,
				}, -- Oculta el botón de cerrar
				error_selected = {
					bg = macchiato.surface0,
				},
				fill = {
					bg = macchiato.base,
				},
				modified_selected = {
					fg = macchiato.yellow,
					bg = macchiato.surface0,
				},
				separator = {
					fg = macchiato.base,
				},
				separator_selected = {
					bg = macchiato.surface0,
					fg = macchiato.base,
				},
				separator_visible = {
					fg = macchiato.base,
				},
				trunc_marker = {
					bg = macchiato.base,
					fg = macchiato.text,
				}, -- Cuando hay demasiados archivos en el bufferline
			},
		},
	}),

	options = {
		separator_style = "slope",
		diagnostics = "nvim_lsp",
		modified_icon = "󰗐",
		show_close_icon = false,
		show_buffer_close_icons = false,
		color_icons = false, -- iconos mono cromáticos
		offsets = {
			{
				filetype = "neo-tree",
				text = "󰥩  File Explorer",
			},
		},
	},
})
