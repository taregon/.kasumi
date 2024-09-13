-- Importa el módulo de utilidades de colores desde el tema Catppuccin.
local u = require("catppuccin.utils.colors")

require("catppuccin").setup({
	flavour = "macchiato",
	background = { dark = "macchiato" },
	color_overrides = {
		macchiato = {
      -- stylua: ignore start
			rosewater = "#7c9da0", -- Links
			flamingo  = "#dde1ed", -- "{" en lua, texto en wich_key
			red       = "#f86c86", -- ALERTA
			pink      = "#ffd4c8", -- Tono Rosado | #fa9e9e $ \n { ┊
			mauve     = "#ffb6c1", -- Barra (visual) | Comando (set, remap), loading [===].
			peach     = "#FFBD5A", -- Barra (comando) | Valores
			yellow    = "#F8E08E", -- ALERTA Warning
			green     = "#AFEEAE", -- Barra (insert) | ALERTA | STRINGS
			teal      = "#608f8b", -- (plug)
			sky       = "#f789cd", -- < = > >> is not
			maroon    = "#fb89a3", -- Parámetros de script
			sapphire  = "#aeffd2", -- EOF - Esta bonito
			blue      = "#a9ecff", -- Barra lados
			lavender  = "#E2A9F3", -- Texto en los conf | Nro linea actual
			text      = "#c5cdd0", -- Texto de la Barra y texto
            subtext0  = "#f7fbfb", -- variables en python
			subtext1  = "#b4d8a9", -- TEXTO / STRING
			overlay2  = "#718C99", -- . , [] () : { y Letras menu desplegable
			overlay0  = "#73838c", -- Comentarios
			surface1  = "#4c585e", -- Numero de linea, resaltado linea horizontal, fin de linea
			surface0  = "#414b50", -- Barra: master, pestaña actual, flechas del tab, fondo menu desplegable lsp, ┊
			base      = "#2e373c", -- A. Fondo
			mantle    = "#384349", -- B. Barra centro, neotree, wichkey, pestañas inactivas, fondo scrollbar, letras lualaine de los extremos
			crust     = "#546269", -- C. Divisor de paneles, fondo pestañas, fondo menu desplegable
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
		variables    = { "italic" },
		-- stylua: ignore end
	},
	custom_highlights = function(colors)
		return {
			--  Con esto separo el color de lualine de las variables de python
			["@variable"] = {
				fg = colors.subtext0,
			},
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
			},
			Pmenu = {
				-- fg = colors.overlay2,
				bg = colors.mantle,
			}, -- Cambia el fondo del menú
			Folded = {
				fg = u.darken(colors.subtext0, 0.8, colors.base), -- Líneas plegadas
				bg = u.darken(colors.subtext0, 0.1, colors.base), -- Igual a DiffChange
				style = { "bold" },
			},
			-- https://github.com/catppuccin/nvim/discussions/448#discussioncomment-5560230
			CursorLine = {
				bg = u.darken(colors.crust, 0.35, colors.base), -- Igual a CursorLineNr
			},
			CursorLineNr = {
				bg = u.darken(colors.crust, 0.50, colors.base), -- Igual a CursorLine
				fg = colors.subtext0,
			},
			-- LineNr = { bg = colors.surface0 },
			-- SignColumn = { bg = colors.surface0 },
			NonText = { fg = colors.surface1 }, -- Carácter de fin de linea
			String = { fg = colors.subtext1 },
		}
	end,
})
-- EL TEMA SE CARGA DESDE AQUI:	https://github.com/catppuccin/nvim?tab=readme-ov-file#configuration
--
vim.cmd.colorscheme("catppuccin")
