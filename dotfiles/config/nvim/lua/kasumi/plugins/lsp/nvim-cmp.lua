-- ┌────────────────────────────────────────────┐
-- │░█▀▀░█▄█░█▀█░░░░░█░░░█░█░█▀█░█▀▀░█▀█░▀█▀░█▀█│
-- │░█░░░█░█░█▀▀░▄█▄░█░░░█░█░█▀█░▀▀█░█░█░░█░░█▀▀│
-- │░▀▀▀░▀░▀░▀░░░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░░│
-- └────────────────────────────────────────────┘
local cmp = require("cmp")
local luasnip = require("luasnip")
luasnip.setup({
	store_selection_keys = "<tab>",
})
local lspkind = require("lspkind")

-- ┌────────────────────────────────────────────┐
--   Aplica los colores de la paleta Catppuccin
--   al borde de la ventana de auto completado
-- └────────────────────────────────────────────┘
local colors = require("catppuccin.palettes").get_palette()
vim.api.nvim_set_hl(0, "CmpComFloatBorder", { fg = colors.green }) -- Usa un color de Catppuccin

-- Carga los snippets.
-- NOTA: admite varias rutas.
require("luasnip.loaders.from_lua").lazy_load({
	paths = {
		"~/.config/nvim/lua/kasumi/goodies/snippets/",
	},
})

-- ────────────────────────────────────────────────────────────
cmp.setup({
	completion = {
		-- 'menu'     : Muestra un menú de opciones de auto completado.
		-- 'menuone'  : Siempre muestra el menú, incluso si solo hay una opción disponible.
		-- 'noselect' : No selecciona automáticamente el primer elemento del menú
		completeopt = "menu,menuone,noselect",
	},

	-- Usa LuaSnip como motor de snippets
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	-- Configura los keymaps / atajos de teclado predeterminados para el modo de inserción
	mapping = cmp.mapping.preset.insert({
		-- Navegar por el menú
		["<Up>"] = cmp.mapping.select_prev_item(),
		["<Down>"] = cmp.mapping.select_next_item(),

		-- Forzar apertura del menú
		["<C-Space>"] = cmp.mapping.complete(),

		-- Cancelar el menú
		["<C-c>"] = cmp.mapping.abort(),

		-- Confirmar selección
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),

	-- Orígenes del auto completado
	sources = cmp.config.sources({
		{ name = "luasnip" }, -- snippets
		{ name = "nvim_lsp" }, -- LSP
		{ name = "nvim_lua" }, -- APIs de Neovim
		{ name = "buffer" }, -- Textos del buffer actual
		{ name = "path" }, -- rutas del sistema
	}),

	-- Iconos para LSP
	formatting = {
		fields = { "abbr", "kind", "menu" }, -- Agrupa los iconos en el menú
		format = function(entry, item)
			-- 1. Obtener info de color
			local color_item = require("nvim-highlight-colors").format(entry, {
				kind = item.kind,
			})

			-- 2. Aplicar lspkind (configuración original)
			item = lspkind.cmp_format({
				mode = "symbol_text",
				maxwidth = 50,
				ellipsis_char = "󱗘 ",
			})(entry, item)

			-- 3. Si hay color, sobrescribir icono + highlight
			if color_item and color_item.abbr_hl_group then
				item.kind_hl_group = color_item.abbr_hl_group
				item.kind = color_item.abbr
			end

			return item
		end,
	},

	-- Agregando bordes al menu de auto completado
	window = {
		completion = cmp.config.window.bordered({
			border = "single",
		}),
		documentation = cmp.config.window.bordered({
			border = "single",
		}),
	},
})
