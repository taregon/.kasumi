-- Para ver mas ajustes
-- :h bufferline-configuration
--
local macchiato = require("catppuccin.palettes").get_palette("macchiato")

require("bufferline").setup({
	highlights = require("catppuccin.special.bufferline").get_theme({
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
					-- fg = macchiato.yellow,
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
		custom_filter = function(buf_number)
			local buf_name = vim.fn.bufname(buf_number)

			-- ─[ EXCLUIR DEL BUFFER ]───────────────────────────────────
			-- Para visualizar rutas completas, usa `:echo expand('%:p')`
			if buf_name:match("^gitsigns://") then
				return false
			end

			if buf_name:match("Grug FAR") then
				return false
			end
			-- Mostrar todos los demás
			return true
		end,

		separator_style = "slope",

		--[[ diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level)
			local icon = level:match("error") and " " or " "
			return " " .. icon .. count
		end, ]]

		modified_icon = " ",
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
