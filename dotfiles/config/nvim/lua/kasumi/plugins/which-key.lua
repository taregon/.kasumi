require("which-key").setup({
	preset = "modern",
	icons = {
		separator = "",
		breadcrumb = "",
	},
})
require("which-key.health").check()

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
})
