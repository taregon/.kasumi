-- Importa el módulo de utilidades de colores desde el tema Catppuccin.
local u = require("catppuccin.utils.colors")

require("catppuccin").setup({
	flavour = "macchiato",
	background = { dark = "macchiato" },
	color_overrides = {
		macchiato = {
      -- stylua: ignore start
			rosewater = "#7c9da0", -- Links
			flamingo  = "#b8bedd", -- "{" en lua
			red       = "#fb6d71", -- ALERTA
			pink      = "#ffd4c8", -- Tono Rosado | #fa9e9e $ \n { ┊
			mauve     = "#ffb6c1", -- Barra (visual) | Comando (set, remap), loading [===].
			peach     = "#ffba51", -- Barra (comando) | Valores
			yellow    = "#F8E08E", -- ALERTA Warning
			green     = "#AFEEAE", -- Barra (insert) | ALERTA | STRINGS
			teal      = "#608f8b", -- (plug)
			sky       = "#f789cd", -- < = > >> is not
			maroon    = "#fb89a3", -- Parámetros de script
			sapphire  = "#aeffd2", -- EOF - Esta bonito
			blue      = "#a7e0f0", -- Barra lados
			lavender  = "#e0a4f2", -- Texto en los conf | Nro linea actual
			text      = "#dadde4", -- Texto de la Barra y texto
			subtext1  = "#b4d8a9", -- TEXTO / STRING
			overlay2  = "#86a29f", -- . , [] () : { y Letras menu desplegable
			overlay0  = "#6c7682", -- Comentarios
			surface1  = "#4c5057", -- Numero de linea, resaltado linea horizontal, fin de linea
			surface0  = "#3e434c", -- Barra: master, pestaña actual, flechas del tab, fondo menu desplegable lsp, ┊
			base      = "#292d32", -- A. Fondo
			mantle    = "#32373f", -- B. Barra centro, neotree, wichkey, pestañas inactivas, fondo scrollbar, letras lualaine de los extremos
			crust     = "#595c62", -- C. Divisor de paneles, fondo pestañas, fondo menu desplegable
			-- stylua: ignore end
		},
	},
	integrations = { -- Extiende los colores a los plug soportados
		gitgutter = true,
		fidget = true,
		diffview = true,
		neotree = true,
		which_key = false, -- Considero que mejor desactivado
		navic = {
			enabled = true,
			-- custom_bg = require("catppuccin.palettes").get_palette("macchiato").surface1, -- "lualine" will set background to mantle
		},
		mini = {
			enabled = true,
			indentscope_color = "pink",
		},
	},
	styles = { -- Sino sabes que cambia, coloca: standout
    -- stylua: ignore start
		booleans     = { "underdotted" },
		comments     = {}, -- Aquí desactivas globalmente el italic de los comentarios
		conditionals = { "italic" },
		functions    = { "italic" },
		keywords     = { "italic" },
		numbers      = { "underdotted" },
		operators    = { "altfont" },
		properties   = { "italic" },
		strings      = {}, -- NONE
		-- types        = { "altfont" },
		types        = { "bold" },
		variables    = { "altfont" },
		-- stylua: ignore end
	},
	custom_highlights = function(colors)
		return {
			DiffDelete = {
				fg = u.darken(colors.red, 0.6, colors.base),
				bg = u.darken(colors.red, 0.1, colors.base),
			},
			DiffAdd = {
				fg = u.darken(colors.green, 0.9, colors.base),
				bg = u.darken(colors.green, 0.1, colors.base),
			},
			DiffChange = {
				fg = u.darken(colors.yellow, 0.4, colors.base), -- Texto inactivo
				bg = u.darken(colors.yellow, 0.06, colors.base), -- Igual a DiffText
			},
			DiffText = {
				fg = u.darken(colors.yellow, 0.85, colors.base), -- Texto modificado
				bg = u.darken(colors.yellow, 0.06, colors.base), -- Igual a DiffChange
			},
			MsgArea = {
				fg = u.darken(colors.text, 0.8, colors.base), -- Area de comandos
				-- bg = u.darken(colors.yellow, 0.8, colors.base),
			},

			-- https://github.com/catppuccin/nvim/discussions/448#discussioncomment-5560230
			CursorLine = {
				bg = u.vary_color(
					{ macchiato = u.lighten(colors.base, 0.70, colors.surface1) },
					u.darken(colors.base, 0.70, colors.surface1)
				),
			},
			NonText = { fg = colors.surface1 }, -- Carácter de fin de linea
			String = { fg = colors.subtext1 },
			CursorLineNr = { fg = colors.peach, bg = colors.surface0 }, -- Numero de linea
			-- LineNr = { bg = colors.surface0 },
			-- SignColumn = { bg = colors.surface0 },
		}
	end,
})
-- EL TEMA SE CARGA DESDE AQUI:	https://github.com/catppuccin/nvim?tab=readme-ov-file#configuration
--
vim.cmd.colorscheme("catppuccin")
