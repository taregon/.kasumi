-- ┌────────────────────────────────────────┐
-- │░▀█▀░█▀▄░█▀▀░█▀▀░█▀▀░▀█▀░▀█▀░▀█▀░█▀▀░█▀▄│
-- │░░█░░█▀▄░█▀▀░█▀▀░▀▀█░░█░░░█░░░█░░█▀▀░█▀▄│
-- │░░▀░░▀░▀░▀▀▀░▀▀▀░▀▀▀░▀▀▀░░▀░░░▀░░▀▀▀░▀░▀│
-- └────────────────────────────────────────┘
-- Lista de lenguajes soportados
-- https://github.com/nvim-treesitter/nvim-treesitter/blob/main/SUPPORTED_LANGUAGES.md

local nts = require("nvim-treesitter")

local ts_parsers = {
	"awk",
	"bash",
	"comment",
	"css",
	"csv",
	"desktop",
	"diff",
	"dockerfile",
	"doxygen",
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
	"kitty",
	"latex",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"mermaid",
	"nginx",
	"passwd",
	"pem",
	"printf",
	"python",
	"rasi",
	"regex",
	"requirements",
	"robots_txt",
	"rust",
	"snakemake",
	"sql",
	"ssh_config",
	"styled",
	"tmux",
	"todotxt",
	"toml",
	"tsv",
	"tsx",
	"udev",
	"vhs",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
	"yuck",
	"zathurarc",
	"zsh",
}

for _, parser in ipairs(ts_parsers) do
	nts.install(parser)
end
