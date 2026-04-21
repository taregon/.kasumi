-- ┌──────────────────────────────────────┐
-- │░█░░░█▀▀░█▀█░░░█▀▀░█▀█░█▀█░█▀▀░▀█▀░█▀▀│
-- │░█░░░▀▀█░█▀▀░░░█░░░█░█░█░█░█▀▀░░█░░█░█│
-- │░▀▀▀░▀▀▀░▀░░░░░▀▀▀░▀▀▀░▀░▀░▀░░░▀▀▀░▀▀▀│
-- └──────────────────────────────────────┘
-- Facilita conectar Neovim con servidores LSP para autocompletado,
-- diagnósticos y navegación de código.
--
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

-- ┌────────────────────────────────────────────────────────────────────┐
--   NOTA: Solo aplica con filetypes y capabilities compartidos.
--  1. Si algún servidor requiere ajustes específicos (por ej. settings),
--     debe declararse fuera de este bloque, como el caso de yamlls.
--  2. Se usan los nombres abreviados tal como aparecen en Mason;
--     si en algún caso fallan, será necesario reemplazarlos por
--     el nombre completo del servidor LSP.
-- └────────────────────────────────────────────────────────────────────┘
-- stylua: ignore
local lsp_servers = {
	bashls   = { "bash", "sh" },
	cssls    = { "css" },
	dockerls = { "dockerfile" },
	graphql  = { "graphql" },
	html     = { "html" },
	jsonls   = { "json", "jsonc" },
	marksman = { "markdown" },
	tombi    = { "toml" },
	ty       = { "python" },
}

for name, types in pairs(lsp_servers) do
	vim.lsp.config[name] = {
		filetypes = types,
		capabilities = lsp_capabilities,
	}
	vim.lsp.enable(name)
end

-- ──────────────────────────< YAML >───────────────────────
vim.lsp.config["yamlls"] = {
	filetypes = { "yaml" },
	capabilities = lsp_capabilities,
	settings = {
		yaml = {
			schemas = {
				kubernetes = {
					"k8s/**/*.yaml",
					"**/*k8s*.yaml",
					"kubernetes/**/*.yaml",
				},
			},
		},
	},
}
vim.lsp.enable("yamlls")

-- ───────────────────────────< LUA >───────────────────────────
vim.lsp.config["lua_ls"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { ".git" },
	capabilities = lsp_capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- library = vim.api.nvim_get_runtime_file("", true), -- Esta linea eleva el CPU
				library = { [vim.fn.stdpath("config")] = true }, -- limita el diagnostico a ~/.config/nvim/
				checkThirdParty = false,
			},
			telemetry = {
				enable = false,
			},
		},
	},
}
vim.lsp.enable("lua_ls")

-- ────────────────────────────────────────────────────────────
-- ast-grep es principalmente CLI; el editor solo lo integra
-- El LSP añade diagnósticos y fixes si hay reglas definidas
-- Sin sgconfig.yml, su uso práctico se limita al CLI
-- https://ast-grep.github.io/reference/languages.html

vim.lsp.config["ast_grep"] = {
	cmd = { "ast-grep", "lsp" },
	filetypes = {
		"bash",
		"css",
		"go",
		"html",
		"java",
		"javascript",
		"json",
		"lua",
		"python",
		"rust",
		"typescript",
		"yaml",
	},
	root_markers = { "sgconfig.yaml", "sgconfig.yml" },
}
vim.lsp.enable("ast_grep")
