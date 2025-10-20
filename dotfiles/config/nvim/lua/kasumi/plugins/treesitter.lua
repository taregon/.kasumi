---@diagnostic disable:missing-fields
-- Habilita el coloreado de texto para los siguientes lenguajes
require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"awk",
		"bash",
		"comment",
		"csv",
		"diff",
		"dockerfile",
		"editorconfig",
		"git_config",
		"git_rebase",
		"gitattributes",
		"gitcommit",
		"gitignore",
		"gpg",
		"hlsplaylist",
		"html",
		"http",
		"ini",
		"jq",
		"json",
		"json5",
		"jsonc",
		"julia",
		"lua",
		"luadoc",
		"luap",
		"luau",
		"markdown",
		"markdown_inline",
		"passwd",
		"pem",
		"printf",
		"python",
		"query",
		"readline",
		"regex",
		"requirements",
		"robots",
		"sql",
		"ssh_config",
		"sxhkdrc",
		"textproto",
		"tlaplus",
		"tmux",
		"udev",
		"vhs",
		"vim",
		"vimdoc",
		"xcompose",
		"xml",
		"yaml",
		"yuck",
		"zathurarc",
	},
	sync_install = true,
	auto_install = true,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = false, -- Solo se aplicarán las reglas de Treesitter,
	},
	-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#indentation
	indent = { enable = true }, -- Habilita la indentación. EXPERIMENTAL
})

-- Este plugin muestra el CONTEXTO actual en la parte superior de la ventana mientras navegas por el código.
-- Por si te cansas de navic, puedes activar esto
require("treesitter-context").setup({
	enable = false,
})

-- Configuración para autotag
require("nvim-ts-autotag").setup({
	opts = {
		enable_close = true, -- Auto close tags
		enable_rename = true, -- Auto rename pairs of tags
	},
})
