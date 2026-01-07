-- ┌──────────────────────────────────┐
-- │░█░█░█░█░▀█▀░█▀▀░█░█░░░█░█░█▀▀░█░█│
-- │░█▄█░█▀█░░█░░█░░░█▀█░░░█▀▄░█▀▀░░█░│
-- │░▀░▀░▀░▀░▀▀▀░▀▀▀░▀░▀░░░▀░▀░▀▀▀░░▀░│
-- └──────────────────────────────────┘
-- NOTA: Carga las funciones para algunos atajos
-- Para no saturar este archivo, las funciones las coloco
-- en keymaps.lua y las invoco con la ´k´
local k = require("kasumi/keymaps")

-- ────────────────────────────────────────────────────────────
require("which-key").setup({
	preset = "modern",
	icons = {
		separator = "",
		breadcrumb = "",
		mappings = false, -- desactiva todos los iconos en los mappings
	},
})
require("which-key.health").check()

-- ────────────────────────────────────────────────────────────
-- FUNCIÓN PARA ALTERNAR VIRTUAL TEXT
local toggle_virtual_text = function()
	local current = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not current })
	if not current then
		vim.notify("Virtual Text ACTIVADO")
	else
		vim.notify("Virtual Text DESACTIVADO")
	end
end

-- ╒═══════════════════════════════════════════════════════════╕
-- │                          ATAJOS                           │
-- ╘═══════════════════════════════════════════════════════════╛
require("which-key").add({
	-- ──────────────────────< COMMENT BOX >───────────────────────
	-- Puedes ver mas estilos ejecutando :CBcatalog
	-- Repo: https://github.com/LudoPinelli/comment-box.nvim
	{ "<leader>c", group = "󱜾  Boxes", mode = { "n", "v" } },
	-- ────────────────────────────────────────────────────────────
	{ "<leader>ca", ":CBlabox20<CR>", desc = "Title Squared (adaptive)", mode = "v" },
	{ "<leader>cc", ":CBlcline8<CR>", desc = "Title Spiked (center)" },
	{ "<leader>cs", ":CBllline1<CR>", desc = "Title Line (left)" },
	{ "<leader>cx", ":CBllline6<CR>", desc = "Title Line Squared (left)" },
	{ "<leader>cb", ":CBlcbox8<CR>", desc = "Box" },
	{ "<leader>cl", ":CBline<CR>", desc = "Line" },
	{ "<leader>cr", ":CBd<CR>", desc = "Remove", mode = "v" },
	-- ───────────────────────< DIAGNOSTICS >───────────────────────
	-- Debido a nuevas actualizaciones, los mensajes del linter / LSP
	-- ya no se muestran así que se activan por atajos
	{ "<leader>t", group = "󰂖  Diagnostic", mode = { "n", "v" } },
	-- ────────────────────────────────────────────────────────────
	{ "<leader>tt", toggle_virtual_text, desc = "Toggle Virtual Text" },
	{ "<leader>tr", vim.diagnostic.open_float, desc = "Show diagnostic" },
	{ "<leader>ti", ":set invlist! | Gitsigns toggle_signs<CR>", desc = "Toggle Special Chars" },
	{ "<leader>tn", ":set invnumber! invrelativenumber!<CR>", desc = "Toggle Line Numbers" },
	-- ────────────────────────────────────────────────────────────
	{ "<leader>g", group = "  Hunks", mode = { "n", "v" } },
	-- ────────────────────────────────────────────────────────────
	{ "h", ":Gitsigns next_hunk<CR>", desc = "Next hunk" }, -- Experimental
	{ "<leader>gp", ":Gitsigns preview_hunk_inline<CR>", desc = "Preview hunk inline" },
	{ "<leader>gh", ":Gitsigns select_hunk<CR>", desc = "Select hunk" },
	{ "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", desc = "Undo stage hunk" },
	{ "<leader>gs", ":Gitsigns stage_hunk<CR>", desc = "Stage current hunk", mode = "v" },
	{ "<leader>gb", ":Gitsigns stage_buffer<CR>", desc = "Stage entire buffer" },
	{ "<leader>gr", ":Gitsigns reset_hunk<CR>", desc = "Reset selected hunk", mode = "v" },
	{ "<leader>gr", ":Gitsigns reset_hunk<CR>", desc = "Reset current hunk", mode = "n" },
	{ "<leader>gi", ":Gitsigns preview_hunk_inline<CR>", desc = "Inline hunk preview" },
	{ "<leader>gc", ":Git commit<CR>", desc = "Create commit" },
	-- ────────────────────────────────────────────────────────────
	{ "<leader>q", group = "󰚔  QuickFix", mode = { "n", "v" } },
	-- ────────────────────────────────────────────────────────────
	-- { "<leader>qt", ":TodoQuickFix<CR>", desc = "TODOs" },
	{ "<leader>qd", k.show_todos_dir, desc = "Show TODOs directory" },
	{ "<leader>qf", k.show_todos_file, desc = "Show TODOs file" },
	{ "<leader>qQ", ":lua require('gitsigns').setqflist('all')<CR>", desc = "Repo changes" },
	{ "<leader>qq", ":lua require('gitsigns').setqflist()<CR>", desc = "Buffer changes" },
	-- ────────────────────────────────────────────────────────────
	{ "m", group = "  Move text", mode = { "n", "v" } },
	-- ────────────────────────────────────────────────────────────
	-- Solo documentación para which-key; los mappings reales los define mini.move
	{ "mh", desc = "Move left" },
	{ "mj", desc = "Move down" },
	{ "mk", desc = "Move up" },
	{ "ml", desc = "Move right" },
	-- ────────────────────────────────────────────────────────────
	--  Abre un split vertical en Kitty usando el directorio del archivo abierto en Neovim
	{ "<leader>l", k.vsplit_in_bufdir, desc = "Kitty vsplit here" },
})
