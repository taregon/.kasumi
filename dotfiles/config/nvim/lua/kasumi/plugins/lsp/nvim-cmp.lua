-- Requiere nvim-cmp y las fuentes de auto completado
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

-- Cargar los colores de Catppuccin
local colors = require("catppuccin.palettes").get_palette()
vim.api.nvim_set_hl(0, "CmpComFloatBorder", { fg = colors.green }) -- Usa el color azul de Catppuccin

-- Carga los snippets.
-- Nota: admite varias rutas.
require("luasnip.loaders.from_lua").load({
	paths = {
		"~/.config/nvim/lua/kasumi/goodies/snippets/",
	},
})
--          _
--  ___ _ _|_|_____ ___ ___ _____ ___
-- |   | | | |     |___|  _|     | . |
-- |_|_|\_/|_|_|_|_|   |___|_|_|_|  _|
--                               |_|
cmp.setup({
	completion = {
		-- 'menu'     : Muestra un menú de opciones de auto completado.
		-- 'menuone'  : Siempre muestra el menú, incluso si solo hay una opción disponible.
		-- 'preview'  : Muestra una ventana de vista previa
		-- 'noselect' : No selecciona automáticamente el primer elemento del menú
		completeopt = "menu,menuone,preview,noselect",
	},

	-- Usa LuaSnip como motor de snippets
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},

	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Acepta la selección con Enter
		["<tab>"] = cmp.mapping(function(original)
			if cmp.visible() then
				cmp.select_next_item() -- run completion selection if completing
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump() -- expand snippets
			else
				original() -- run the original behavior if not completing
			end
		end, { "i", "s" }),
		["<S-tab>"] = cmp.mapping(function(original)
			if cmp.visual() then
				cmp.select_prev_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.jump(-1)
			else
				original()
			end
		end, { "i", "s" }),
	}),

	-- Orígenes del auto completado
	sources = cmp.config.sources({
		{ name = "buffer" }, -- Textos del buffer actual
		{ name = "luasnip" }, -- snippets
		{ name = "nvim_lsp" }, -- LSP
		{ name = "path" }, -- rutas del sistema
		{ name = "supermaven" },
	}),

	-- Iconos para LSP
	formatting = {
		format = lspkind.cmp_format({
			fields = { "abbr", "kind", "menu" }, -- Agrupa los iconos en el menú
			mode = "symbol_text",
			maxwidth = 50,
			ellipsis_char = "󱗘 ",
			symbol_map = {
				Supermaven = "",
			},
		}),
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
