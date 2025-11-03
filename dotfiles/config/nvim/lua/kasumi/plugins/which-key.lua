require("which-key").setup({
	preset = "modern",
	icons = {
		separator = "",
		breadcrumb = "",
	},
})
require("which-key.health").check()

-- ╒═══════════════════════════════════════════════════════════╕
-- │            Función para alternar virtual text             │
-- ╘═══════════════════════════════════════════════════════════╛
local toggle_virtual_text = function()
	local current = vim.diagnostic.config().virtual_text
	vim.diagnostic.config({ virtual_text = not current })
	if not current then
		vim.notify("Virtual text ACTIVADO")
	else
		vim.notify("Virtual text DESACTIVADO")
	end
end

-- ┌──────────────────────────────────┐
-- │░█░█░█░█░▀█▀░█▀▀░█░█░░░█░█░█▀▀░█░█│
-- │░█▄█░█▀█░░█░░█░░░█▀█░░░█▀▄░█▀▀░░█░│
-- │░▀░▀░▀░▀░▀▀▀░▀▀▀░▀░▀░░░▀░▀░▀▀▀░░▀░│
-- └──────────────────────────────────┘
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
	{ "<leader>ti", ":set invlist!<CR>:GitGutterSignsToggle<CR>", desc = "Toggle Special Chars" },
	{ "<leader>tn", ":set invnumber! invrelativenumber!<CR>", desc = "Toggle Line Numbers" },
	-- ────────────────────────────────────────────────────────────
	{ "<leader>g", group = "  Hunks", mode = { "n", "v" } },
	-- ────────────────────────────────────────────────────────────
	{ "<leader>gp", ":Gitsigns preview_hunk<CR>", desc = "Preview hunk" },
	{ "<leader>gr", ":Gitsigns reset_hunk_inline<CR>", desc = "Revert hunk" },
	{ "<leader>gs", ":Gitsigns stage_hunk<CR>", desc = "Stage hunk", mode = "v" },
})
