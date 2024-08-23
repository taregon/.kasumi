local u = require("catppuccin.utils.colors")

require("catppuccin").setup({
	--    dim_inactive = {
	--      enabled = true,
	--      shade = "dark",
	--      percentage = 0.9,
	--    },
	flavour = "macchiato",
	background = { dark = "macchiato" },
	color_overrides = {
		macchiato = {
      -- stylua: ignore start
			rosewater = "#7c9da0", -- Links #86b9c7 #7d9aa2
			flamingo  = "#b8bedd", -- "{" en lua #bf407b #AC89C9 #AD8FE5 #84719b #c8c0a9
			red       = "#ff6d74", -- ALERTA #e23667 #FF4235 #aa3151 #E54874
			pink      = "#ffa697", -- Tono Rosado | #fa9e9e $ \n { ┊
			mauve     = "#ffb6c1", -- Barra (visual) | Comando (set, remap) #ea6a8e #E6527C #ed6a92 #ff9dbf
			peach     = "#ffb94e", -- Barra (comando) | Valores #F0C483 #ffd1ac
			yellow    = "#ffe78c", -- ALERTA Warning
			green     = "#cceca4", -- Barra (Normal) | ALERTA | STRINGS
			teal      = "#608f8b", -- (plug)
			sky       = "#f364a2", -- < = > >> is not #fff35a #ffe11f #eb88a4
			maroon    = "#de70a1", -- Parámetros de script #d89287 #d27990 #97a5c3 #a6acc7
			sapphire  = "#9EEFC0", -- EOF - Esta bonito
			blue      = "#a4dded", -- Barra lados #4AC4E5 #75D2EB #27d3d4
			lavender  = "#c59dd8", -- Texto en los conf | Nro linea actual #B9CFD4 #a8abbe #B087CC #b785b5
			text      = "#ced1d8", -- Texto de la Barra y texto #f5e8e8 #d8d3cf #e5e2e4 #e4dcd8"#d8d8d7
			subtext1  = "#addfad", -- TEXTO / STRING
			overlay2  = "#86aba5", -- . , [] () : { y Letras menu desplegable #9b9fc8
			-- overlay1  = "#c4c0d0", -- ahora Texto?
			overlay0  = "#858c9b", -- Comentarios #5a636f #7c81a2 #7a8188 #6a8188 #67787e
			surface1  = "#505662", -- Numero de linea, resaltado linea horizontal, tabs #4e555a
			surface0  = "#43484f", -- Barra: master, fondo pestaña, tab, ┊
			base      = "#2f333b", -- A. Fondo #1F2127 #2d2d45 #23272d  #21232a #272930 #22262c #282C34 #24282f #24272e
			mantle    = "#3b4048", -- B. Barra centro, neotree, wichkey, & letras
			crust     = "#2c3036", -- C. Divisor de paneles, fondo pestañas, fondo menu desplegable
			-- stylua: ignore end
		},
	},
	integrations = { -- Extiende los colores a los plug soportados
		gitgutter = true,
		neotree = true,
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
		comments     = {}, -- NONE
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
			CursorLine = {
				bg = u.vary_color(
					{ macchiato = u.lighten(colors.base, 0.70, colors.surface1) },
					u.darken(colors.base, 0.70, colors.surface1)
				), -- https://github.com/catppuccin/nvim/discussions/448#discussioncomment-5560230
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
vim.cmd.colorscheme("catppuccin")
