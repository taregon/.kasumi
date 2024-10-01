-- Requiere nvim-cmp y las fuentes de auto completado
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
-- Cargar los colores de Catppuccin
local colors = require("catppuccin.palettes").get_palette()
vim.api.nvim_set_hl(0, "CmpComFloatBorder", { fg = colors.green }) -- Usa el color azul de Catppuccin

--    __             ____     _
--   / /  __ _____ _/ __/__  (_)__
--  / /__/ // / _ `/\ \/ _ \/ / _ \
-- /____/\_,_/\_,_/___/_//_/_/ .__/
--                          /_/
require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/kasumi/goodies/" })

--             _
--   ___ _  __(_)_ _  __________ _  ___
--  / _ \ |/ / /  ' \/___/ __/  ' \/ _ \
-- /_//_/___/_/_/_/_/    \__/_/_/_/ .__/
--                               /_/
--
cmp.setup({
	-- completion = {
	-- 	completeopt = "menu,menuone,preview,noselect",
	-- },
	-- Usa LuaSnip como motor de snippets
	snippet = {
		expand = function(a)
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
		{ name = "buffer" }, -- Texto del buffer actual
		{ name = "nvim_lsp" }, -- LSP
		{ name = "path" }, -- rutas del sistema
		{ name = "luasnip" }, -- snippets
	}),
	-- Iconos para LSP
	formatting = {
		format = lspkind.cmp_format({
			fields = { "abbr", "kind", "menu" }, -- Agrupa los iconos en el menú
			mode = "symbol_text",
			maxwidth = 50,
			ellipsis_char = "...",
		}),
	},
	-- Agregando bordes al menu de auto completado
	window = {
		completion = cmp.config.window.bordered({
			border = "single",
			-- winhighlight = "FloatBorder:CmpComFloatBorder,",
		}),
		documentation = cmp.config.window.bordered({
			border = "single",
		}),
	},
})
