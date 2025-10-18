--  ██████╗ █████╗ ████████╗██████╗ ██████╗ ██╗   ██╗ ██████╗ ██████╗██╗███╗   ██╗
-- ██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗██║   ██║██╔════╝██╔════╝██║████╗  ██║
-- ██║     ███████║   ██║   ██████╔╝██████╔╝██║   ██║██║     ██║     ██║██╔██╗ ██║
-- ██║     ██╔══██║   ██║   ██╔═══╝ ██╔═══╝ ██║   ██║██║     ██║     ██║██║╚██╗██║
-- ╚██████╗██║  ██║   ██║   ██║     ██║     ╚██████╔╝╚██████╗╚██████╗██║██║ ╚████║
--  ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝      ╚═════╝  ╚═════╝ ╚═════╝╚═╝╚═╝  ╚═══╝

-- Importa el módulo de utilidades de colores desde el tema Catppuccin.
local u = require("catppuccin.utils.colors")

require("catppuccin").setup({
	flavour = "macchiato",
	-- background = { dark = "macchiato" },
	color_overrides = {
		macchiato = {
			-- stylua: ignore start
			rosewater = "#6f808a", -- Links
			flamingo  = "#9DB2B2", -- "{" en lua, texto en wich_key
			red       = "#f86e88", -- ALERTA #f17b8b #f86c86
			pink      = "#8d9fc9", -- Tono Rosado | #fa9e9e $ \n { ┊
			mauve     = "#ff9dcd", -- Barra (visual) | Comando (set, remap), loading [=== ].
			peach     = "#ffcf94", -- Barra (comando) | Valores
			yellow    = "#f8e084", -- ALERTA Warning
			green     = "#80c8a1", -- Barra (insert) | ALERTA | STRINGS
			teal      = "#89DCEB", -- (plug)
			sky       = "#f8a984", -- < =  > >> is not or
			maroon    = "#b3a7e5", -- Opciones en scripts
			sapphire  = "#bef7df", -- 'EOF' - Esta bonito
			blue      = "#a7d6fa", -- Barra lados, setup
			lavender  = "#eabdf6", -- Texto en los conf | Nro linea actual
			text      = "#c0cdd3", -- Texto de la Barra y texto
			subtext0  = "#f2f4fb", -- variables en python
			subtext1  = "#cbe79f", -- TEXTO / STRING
			overlay2  = "#8598b2", -- . , [] () : { y Letras menu desplegable
			overlay1  = "#9eb7c6", -- Fondo de los 'folds'
			overlay0  = "#5d6c74", -- Comentarios
			surface1  = "#4a585f", -- Numero de linea, resaltado linea horizontal, (end-of-line)
			surface0  = "#414b50", -- Barra: master, pestaña actual, flechas del tab, fondo menu desplegable lsp, ┊
			base      = "#2e383d", -- A. Fondo
			mantle    = "#354146", -- B. Barra centro, neotree, wichkey, pestañas inactivas, fondo scrollbar, letras lualaine de los extremos, fondo menu
			crust     = "#49575e", -- C. Divisor de paneles, fondo pestañas,
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

	-- ╒═══════════════════════════════════════════════════════════╕
	-- │                Mas Colores Personalizados                 │
	-- ╘═══════════════════════════════════════════════════════════╛
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
				bg = colors.mantle, -- Cambia el fondo del menú
			},
			Folded = {
				fg = u.darken(colors.overlay1, 0.7, colors.base), -- Líneas plegadas
				bg = u.darken(colors.overlay0, 0.1, colors.base), -- Lineas plegadas
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
			NonText = {
				fg = colors.surface1,
			}, -- Carácter de fin de linea
			String = {
				fg = colors.subtext1,
			},
			Comment = {
				fg = colors.overlay0,
			},
		}
	end,
})

-- ╒═══════════════════════════════════════════════════════════╕
-- │                EL TEMA SE CARGA DESDE AQUÍ                │
-- ╘═══════════════════════════════════════════════════════════╛
-- https://github.com/catppuccin/nvim?tab=readme-ov-file#configuration
vim.cmd.colorscheme("catppuccin")
