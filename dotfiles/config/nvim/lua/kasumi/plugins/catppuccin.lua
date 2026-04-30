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
			-- ÁREA 1: Colores principales del tema (orden numérico por hex)
			rosewater = "#6F808A", -- Links
			flamingo  = "#9DB2B2", -- "{" en lua, texto en wich_key
			green     = "#80C8A1", -- Barra (insert) | ALERTA | STRINGS
			teal      = "#89DCEB", -- (plug)
			pink      = "#8D9FC9", -- Tono Rosado | #fa9e9e $ \n { ┊
			blue      = "#A7D6FA", -- Barra lados, setup
			maroon    = "#B3A7E5", -- Opciones en scripts
			sapphire  = "#BEF7DF", -- 'EOF' - Esta bonito
			lavender  = "#EABDF6", -- Texto en los conf | Nro linea actual
			sky       = "#F8A984", -- < =  > >> is not or
			yellow    = "#F8E084", -- ALERTA Warning
			red       = "#F86E88", -- ALERTA #f17b8b #f86c86
			mauve     = "#FF9DCD", -- Barra (visual) | Comando (set, remap), loading [=== ].
			peach     = "#FFCF94", -- Barra (comando) | Valores

			-- ÁREA 2: Colores de texto
			text      = "#C0CDD3", -- Texto de la Barra y texto
			overlay0  = "#5D6C74", -- Comentarios
			overlay1  = "#9EB7C6", -- Fondo de los 'folds'
			overlay2  = "#8598B2", -- . , [] () : { y Letras menu desplegable
			subtext0  = "#F2F4FB", -- variables en python
			subtext1  = "#CBE79F", -- TEXTO / STRING

			-- ÁREA 3: Colores de fondo
			surface0  = "#414E55", -- Barra: master, pestaña actual, flechas del tab, fondo menu desplegable lsp, ┊
			surface1  = "#4A585F", -- Numero de linea, resaltado linea horizontal, (end-of-line)
			base      = "#2E383D", -- A. Fondo
			mantle    = "#343E43", -- B. Barra centro, neotree, wichkey, pestañas inactivas, fondo scrollbar, letras lualine de los extremos, fondo menu
			crust     = "#49575E", -- C. Divisor de paneles, fondo pestañas,
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

			-- ─────────────────────< RENDER MARKDOWN >─────────────────────
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
			},

			-- ────────────────────────< MARKVIEW >─────────────────────
			-- Bloques de código
			MarkviewCode = {
				bg = kas.darken(colors.mantle, 0.8, colors.base),
			},
			MarkviewCodeInfo = {
				fg = colors.overlay0,
				bg = kas.darken(colors.mantle, 0.8, colors.base),
			},
			MarkviewInlineCode = {
				fg = kas.darken(colors.sapphire, 0.80, colors.base),
				bg = kas.darken(colors.green, 0.25, colors.base),
			},

			-- Tablas
			MarkviewTableHeader = {
				fg = kas.darken(colors.blue, 0.55, colors.base),
			},
			MarkviewTableBorder = {
				fg = kas.darken(colors.blue, 0.35, colors.base),
			},
			MarkviewTableAlignLeft = {
				fg = kas.darken(colors.blue, 0.65, colors.base),
			},
			MarkviewTableAlignRight = {
				fg = kas.darken(colors.blue, 0.65, colors.base),
			},
			MarkviewTableAlignCenter = {
				fg = kas.darken(colors.blue, 0.65, colors.base),
			},
			MarkviewIcon4 = {
				fg = kas.darken(colors.blue, 0.65, colors.base),
			},

			-- Checkboxes
			MarkviewCheckboxUnchecked = {
				fg = kas.darken(colors.text, 0.75, colors.base),
			},
			MarkviewCheckboxPending = {
				fg = kas.darken(colors.peach, 0.80, colors.base),
			},
			MarkviewPalette0Fg = {
				fg = kas.darken(colors.maroon, 0.75, colors.base),
			},

			-- Encabezados
			MarkviewHeading2 = {
				fg = kas.darken(colors.peach, 0.95, colors.base),
				bg = kas.darken(colors.peach, 0.12, colors.base),
			},
			MarkviewHeading3 = {
				fg = kas.darken(colors.peach, 0.95, colors.base),
				bg = kas.darken(colors.peach, 0.06, colors.base),
			},
			MarkviewHeading2Sign = {
				fg = kas.darken(colors.base, 0.90, colors.peach),
			},

			-- Listas
			MarkviewListItemMinus = {
				fg = kas.darken(colors.pink, 0.74),
			},

			-- ────────────────────────< SCROLLBAR >────────────────────────
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

		-- ────────────────────────────────────────────────────────────
		-- Genera 9 niveles de gradiente para MarkviewGradient1..9,
		-- interpolando linealmente un factor entre min y max para
		-- oscurecer el color base de forma progresiva y consistente.
		--      for i = 1, steps do
		--      local factor = i * 0.1
		local steps = 9
		local min = 0.05
		local max = 0.25

		for i = 1, steps do
			local factor = min + (max - min) * ((i - 1) / (steps - 1))

			kasumi_colors["MarkviewGradient" .. i] = {
				fg = kas.darken(colors.blue, factor, colors.base),
			}
		end
		return kasumi_colors
	end,
})

-- ────────────────────────────────────────────────────────────
-- EL TEMA SE CARGA DESDE AQUÍ
-- https://github.com/catppuccin/nvim?tab=readme-ov-file#configuration
vim.cmd.colorscheme("catppuccin")
