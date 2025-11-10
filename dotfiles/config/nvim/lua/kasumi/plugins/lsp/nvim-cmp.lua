-- ┌────────────────────────────────────────────┐
-- │░█▀▀░█▄█░█▀█░░░░░█░░░█░█░█▀█░█▀▀░█▀█░▀█▀░█▀█│
-- │░█░░░█░█░█▀▀░▄█▄░█░░░█░█░█▀█░▀▀█░█░█░░█░░█▀▀│
-- │░▀▀▀░▀░▀░▀░░░░▀░░▀▀▀░▀▀▀░▀░▀░▀▀▀░▀░▀░▀▀▀░▀░░│
-- └────────────────────────────────────────────┘
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

-- ┌────────────────────────────────────────────┐
--   Aplica los colores de la paleta Catppuccin
--   al borde de la ventana de auto completado
-- └────────────────────────────────────────────┘
local colors = require("catppuccin.palettes").get_palette()
vim.api.nvim_set_hl(0, "CmpComFloatBorder", { fg = colors.green }) -- Usa u color de Catppuccin

-- Carga los snippets.
-- NOTA: admite varias rutas.
require("luasnip.loaders.from_lua").load({
	paths = {
		"~/.config/nvim/lua/kasumi/goodies/snippets/",
	},
})

-- ────────────────────────────────────────────────────────────
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

	-- mapping = cmp.mapping.preset.insert({
	-- 	["<CR>"] = cmp.mapping.confirm({ select = true }), -- Acepta la selección con Enter
	-- 	["<tab>"] = cmp.mapping(function(original)
	-- 		if cmp.visible() then
	-- 			cmp.select_next_item() -- run completion selection if completing
	-- 		elseif luasnip.expand_or_jumpable() then
	-- 			luasnip.expand_or_jump() -- expand snippets
	-- 		else
	-- 			original() -- run the original behavior if not completing
	-- 		end
	-- 	end, { "i", "s" }),
	-- 	["<S-tab>"] = cmp.mapping(function(original)
	-- 		if cmp.visual() then
	-- 			cmp.select_prev_item()
	-- 		elseif luasnip.expand_or_jumpable() then
	-- 			luasnip.jump(-1)
	-- 		else
	-- 			original()
	-- 		end
	-- 	end, { "i", "s" }),
	-- }),
	-- mapping = cmp.mapping.preset.insert({
	-- 	["<Up>"] = cmp.mapping.select_prev_item(),
	-- 	["<Down>"] = cmp.mapping.select_next_item(),
	-- 	["<C-d>"] = cmp.mapping.scroll_docs(-4),
	-- 	["<C-f>"] = cmp.mapping.scroll_docs(4),
	-- 	["<C-Space>"] = cmp.mapping.complete(),
	-- 	["<C-e>"] = cmp.mapping.abort(),
	-- 	["<CR>"] = cmp.mapping.confirm({ select = true }),
	-- }),
	--
	-- cmp.setup({
	-- 	mapping = {
	-- 		-- Navegar por el menú de autocompletado
	-- 		["<Tab>"] = cmp.mapping(function(fallback)
	-- 			if cmp.visible() then
	-- 				cmp.select_next_item(select_opts) -- siguiente item
	-- 			elseif luasnip.expand_or_jumpable() then
	-- 				luasnip.expand_or_jump() -- expandir snippet o saltar
	-- 			else
	-- 				fallback() -- comportamiento normal de Tab
	-- 			end
	-- 		end, { "i", "s" }),

	-- 		["<S-Tab>"] = cmp.mapping(function(fallback)
	-- 			if cmp.visible() then
	-- 				cmp.select_prev_item(select_opts) -- item anterior
	-- 			elseif luasnip.jumpable(-1) then
	-- 				luasnip.jump(-1) -- saltar hacia atrás en snippet
	-- 			else
	-- 				fallback() -- comportamiento normal de Shift+Tab
	-- 			end
	-- 		end, { "i", "s" }),

	-- 		-- Confirmar selección con Enter
	-- 		["<CR>"] = cmp.mapping.confirm({ select = true }),

	-- 		-- Scroll de documentación
	-- 		["<C-d>"] = cmp.mapping.scroll_docs(-4),
	-- 		["<C-f>"] = cmp.mapping.scroll_docs(4),

	-- 		-- Cerrar menú
	-- 		["<C-e>"] = cmp.mapping.abort(),
	-- 	},
	-- }),

	cmp.setup({
		mapping = cmp.mapping.preset.insert({
			-- Navegar por el menú
			["<Up>"] = cmp.mapping.select_prev_item(),
			["<Down>"] = cmp.mapping.select_next_item(),

			-- REVISAR: Scroll en la ventana de documentación
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),

			-- Forzar apertura del menú
			["<TAB>"] = cmp.mapping.complete(),

			-- Cancelar el menú
			["<C-e>"] = cmp.mapping.abort(),

			-- Confirmar selección
			["<CR>"] = cmp.mapping.confirm({ select = true }),
		}),
	}),

	-- Orígenes del auto completado
	sources = cmp.config.sources({
		{ name = "buffer", dup = 0 }, -- Textos del buffer actual
		{ name = "luasnip" }, -- snippets
		{ name = "nvim_lsp" }, -- LSP
		{ name = "path" }, -- rutas del sistema
		{ name = "supermaven" },
	}),

	-- Iconos para LSP
	formatting = {
		fields = { "abbr", "kind", "menu" }, -- Agrupa los iconos en el menú
		format = lspkind.cmp_format({
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
