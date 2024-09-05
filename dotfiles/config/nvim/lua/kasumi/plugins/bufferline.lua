-- Para ver mas ajustes
-- :h bufferline-configuration
--
local macchiato = require("catppuccin.palettes").get_palette("macchiato")

require("bufferline").setup({
	highlights = require("catppuccin.groups.integrations.bufferline").get({
		styles = { "italic" },
		custom = {
			macchiato = {
				fill = { bg = macchiato.base }, -- Cambia el fondo de las pestañas.

				buffer_selected = {
					bg = macchiato.surface0,
					bold = true,
				},
				close_button_selected = { bg = macchiato.surface0 },
				modified_selected = { bg = macchiato.surface0 },
				separator = { fg = macchiato.base },
				separator_selected = { bg = macchiato.surface0, fg = macchiato.base },
				separator_visible = { fg = macchiato.base },
			},
		},
	}),

	options = {
		separator_style = "slope",
		show_close_icon = false,
		show_buffer_close_icons = false,
		color_icons = false, -- Mono cromático
	},
})
