-- ┌──────────────────────────────────┐
-- │░█░█░█░█░▀█▀░█▀▀░█░█░░░█░█░█▀▀░█░█│
-- │░█▄█░█▀█░░█░░█░░░█▀█░░░█▀▄░█▀▀░░█░│
-- │░▀░▀░▀░▀░▀▀▀░▀▀▀░▀░▀░░░▀░▀░▀▀▀░░▀░│
-- └──────────────────────────────────┘
require("which-key").setup({
	preset = "modern",
	icons = {
		separator = "",
		breadcrumb = "",
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

-- Funciones seguras para navegar quickfix
local function qf_next()
	local ok = pcall(vim.cmd, "cnext")
	if not ok then
		vim.cmd("cfirst")
	end
end

local function qf_prev()
	local ok = pcall(vim.cmd, "cprev")
	if not ok then
		vim.cmd("clast")
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
	{ "<leader>cx", ":CBllline6<CR>", desc = "Title Squared (left)" },
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
	{ "<leader>ti", ":set invlist!<CR>", desc = "Toggle Special Chars" },
	{ "<leader>tn", ":set invnumber! invrelativenumber!<CR>", desc = "Toggle Line Numbers" },
	{ "<leader>tc", "<cmd>lua require('coerce').to_title()<CR>", desc = "Title Case", mode = "v" },
	-- ────────────────────────────────────────────────────────────
	{ "<leader>g", group = "  Hunks", mode = { "n", "v" } },
	-- ────────────────────────────────────────────────────────────
	{ "<leader>gp", ":Gitsigns preview_hunk_inline<CR>", desc = "Preview hunk" },
	{ "<leader>gs", ":Gitsigns stage_hunk<CR>", desc = "Stage hunk", mode = "v" },
	{ "<leader>gr", ":Gitsigns reset_hunk<CR>", desc = "Revert selected lines", mode = "v" },
	{ "<leader>gR", ":Gitsigns reset_hunk<CR>", desc = "Revert current hunk" },
	{ "<leader>qs", qf_next, desc = "Quickfix next" },
	{ "<leader>qw", qf_prev, desc = "Quickfix previous" },
})
