-- Requiere nvim-cmp y las fuentes de auto completado
local cmp = require("cmp")

cmp.setup({
	-- -- Usa LuaSnip como motor de snippets
	-- snippet = {
	-- 	expand = function(args)
	-- 		require("luasnip").lsp_expand(args.body)
	-- 	end,
	-- },
	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Acepta la selección con Enter
	}),
	-- Orígenes del auto completado
	sources = cmp.config.sources({
		{ name = "buffer" }, -- text within the current buffer
		{ name = "nvim_lsp" }, -- LSP
		{ name = "path" }, -- file system paths
		-- { name = "luasnip" }, -- snippets
	}),
})
