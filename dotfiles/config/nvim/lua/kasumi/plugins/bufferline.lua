local macchiato = require("catppuccin.palettes").get_palette("macchiato")

require("bufferline").setup({
	highlights = require("catppuccin.groups.integrations.bufferline").get({
		styles = { "italic" },
		custom = {
			macchiato = {
				fill = { bg = macchiato.crust }, -- Cambia el fondo de las pestañas OK
				buffer_selected = { bg = macchiato.surface0 },
				separator_selected = { bg = macchiato.surface0 },
				close_button_selected = { bg = macchiato.surface0 },
				modified_selected = { bg = macchiato.surface0 },
			},
		},
	}),
	options = {
		separator_style = "slant",
		show_close_icon = false,
		show_buffer_close_icons = false,
	},
})
