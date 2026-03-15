--  ██████╗ █████╗ ████████╗██████╗ ██████╗ ██╗   ██╗ ██████╗ ██████╗██╗███╗   ██╗
-- ██╔════╝██╔══██╗╚══██╔══╝██╔══██╗██╔══██╗██║   ██║██╔════╝██╔════╝██║████╗  ██║
-- ██║     ███████║   ██║   ██████╔╝██████╔╝██║   ██║██║     ██║     ██║██╔██╗ ██║
-- ██║     ██╔══██║   ██║   ██╔═══╝ ██╔═══╝ ██║   ██║██║     ██║     ██║██║╚██╗██║
-- ╚██████╗██║  ██║   ██║   ██║     ██║     ╚██████╔╝╚██████╗╚██████╗██║██║ ╚████║
--  ╚═════╝╚═╝  ╚═╝   ╚═╝   ╚═╝     ╚═╝      ╚═════╝  ╚═════╝ ╚═════╝╚═╝╚═╝  ╚═══╝

-- La escala de colores las genero en https://components.ai/color-scale
-- Opciones: HSV y Natural / RGB y Lineal
-- Comandos útiles para revisar colores
--   :InspectTree para ver grupos de highlight
--   :Inspect para ver el highlight bajo el cursor
-- Colores extras: #f5c2e7

-- Importa el módulo de utilidades de colores desde el tema Catppuccin.
local kas = require("catppuccin.utils.colors")

require("catppuccin").setup({
	flavour = "macchiato",
	-- background = { dark = "macchiato" },
	color_overrides = {
		-- stylua: ignore
		macchiato = {
			-- ÁREA 1: Colores principales del tema (orden cromático por hue)
			sky       = "#f8a984", -- < =  > >> is not or
			mauve     = "#ff9dcd", -- Barra (visual) | Comando (set, remap), loading [=== ].
			peach     = "#ffcf94", -- Barra (comando) | Valores
			yellow    = "#f8e084", -- ALERTA Warning
			green     = "#80c8a1", -- Barra (insert) | ALERTA | STRINGS
			maroon    = "#b3a7e5", -- Opciones en scripts
			sapphire  = "#bef7df", -- 'EOF' - Esta bonito
			blue      = "#a7d6fa", -- Barra lados, setup
			teal      = "#89DCEB", -- (plug)
			lavender  = "#eabdf6", -- Texto en los conf | Nro linea actual
			pink      = "#8d9fc9", -- Tono Rosado | #fa9e9e $ \n { ┊
			flamingo  = "#9DB2B2", -- "{" en lua, texto en wich_key
			rosewater = "#6f808a", -- Links
			red       = "#f86e88", -- ALERTA #f17b8b #f86c86

			-- ÁREA 2: Colores de texto
			text      = "#c0cdd3", -- Texto de la Barra y texto
			overlay0  = "#5d6c74", -- Comentarios
			overlay1  = "#9eb7c6", -- Fondo de los 'folds'
			overlay2  = "#8598b2", -- . , [] () : { y Letras menu desplegable
			subtext0  = "#f2f4fb", -- variables en python
			subtext1  = "#cbe79f", -- TEXTO / STRING

			-- ÁREA 3: Colores de fondo
			surface0  = "#414e55", -- Barra: master, pestaña actual, flechas del tab, fondo menu desplegable lsp, ┊
			surface1  = "#4a585f", -- Numero de linea, resaltado linea horizontal, (end-of-line)
			base      = "#2e383d", -- A. Fondo
			mantle    = "#343e43", -- B. Barra centro, neotree, wichkey, pestañas inactivas, fondo scrollbar, letras lualine de los extremos, fondo menu
			crust     = "#49575e", -- C. Divisor de paneles, fondo pestañas,
		},
	},

	integrations = { -- Extiende los colores a los plug soportados
		diffview = true,
		fidget = true,
		gitsigns = true,
		render_markdown = true,
		mini = {
			enabled = true,
			indentscope_color = "pink",
		},
		navic = {
			enabled = true,
			-- custom_bg = require("catppuccin.palettes").get_palette("macchiato").surface1, -- "lualine" will set background to mantle
		},
		neo_tree = true,
		which_key = false, -- Considero que mejor desactivado
	},

	styles = { -- NOTE: Sino sabes que cambia, coloca: standout
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
	-- │                  COLORES PERSONALIZADOS                   │
	-- ╘═══════════════════════════════════════════════════════════╛
	custom_highlights = function(colors)
		local kasumi_colors = {
			DiffDelete = {
				fg = kas.darken(colors.red, 0.6, colors.base),
				bg = kas.darken(colors.red, 0.1, colors.base),
			},
			DiffAdd = {
				fg = kas.darken(colors.green, 0.9, colors.base),
				bg = kas.darken(colors.green, 0.1, colors.base),
			},
			DiffChange = {
				fg = kas.darken(colors.yellow, 0.4, colors.base), -- Texto inactivo
				bg = kas.darken(colors.yellow, 0.06, colors.base), -- Igual a DiffText
			},
			DiffText = {
				fg = kas.darken(colors.yellow, 0.85, colors.base), -- Texto modificado
				bg = kas.darken(colors.yellow, 0.06, colors.base), -- Igual a DiffChange
			},
			MsgArea = {
				fg = kas.darken(colors.text, 0.8, colors.base), -- Area de comandos
			},
			Pmenu = {
				-- fg = colors.overlay2,
				bg = colors.mantle, -- Cambia el fondo del menú
			},
			Folded = {
				fg = kas.darken(colors.overlay1, 0.7, colors.base), -- Líneas plegadas
				bg = kas.darken(colors.overlay0, 0.1, colors.base), -- Lineas plegadas
				style = { "bold" },
			},
			-- https://github.com/catppuccin/nvim/discussions/448#discussioncomment-5560230
			CursorLine = {
				bg = kas.darken(colors.crust, 0.35, colors.base), -- Igual a CursorLineNr
			},
			CursorLineNr = {
				bg = kas.darken(colors.crust, 0.50, colors.base), -- Igual a CursorLine
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

			-- ─────────────────< COLORES RENDER MARKDOWN >──────────────
			RenderMarkdownCode = {
				bg = kas.darken(colors.mantle, 0.8, colors.base),
			},
			RenderMarkdownCodeInline = {
				bg = colors.mantle,
			},
			RenderMarkdownH1Bg = {
				fg = colors.red,
				bg = kas.darken(colors.red, 0.1, colors.base),
				bold = true,
			},
			RenderMarkdownH2Bg = {
				fg = colors.peach,
				bg = kas.darken(colors.peach, 0.1, colors.base),
				bold = true,
			},
			RenderMarkdownH3Bg = {
				fg = colors.peach,
				bg = kas.darken(colors.peach, 0.1, colors.base),
				-- nocombine = true,
			},

			-- ─────────────────< COLORES NVIM SCROLLBAR >──────────────
			ScrollbarError = {
				fg = colors.red,
			},
			ScrollbarWarn = {
				fg = colors.yellow,
			},
			ScrollbarInfo = {
				fg = colors.sky,
			},
			ScrollbarHint = {
				fg = colors.teal,
			},
		}

		--  Con esto separo el color de lualine de las variables de python
		kasumi_colors["@variable"] = {
			fg = colors.subtext0,
		}

		return kasumi_colors
	end,
})

-- ────────────────────────────────────────────────────────────
-- EL TEMA SE CARGA DESDE AQUÍ
-- https://github.com/catppuccin/nvim?tab=readme-ov-file#configuration
vim.cmd.colorscheme("catppuccin")
