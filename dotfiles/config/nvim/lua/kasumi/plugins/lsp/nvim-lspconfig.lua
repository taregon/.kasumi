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
--   Agrupa y activa servidores LSP con configuración básica.
--   NOTA: Solo aplica con filetypes y capabilities compartidos.
--   Si algún servidor requiere ajustes específicos (por ej. settings),
--   debe declararse fuera de este bloque, como el caso de yamlls.
-- └────────────────────────────────────────────────────────────────────┘
local lsp_servers = {
    -- stylua: ignore start
	bashls   = { "sh" },
	cssls    = { "css" },
	dockerls = { "dockerfile" },
	graphql  = { "graphql" },
	html     = { "html" },
	jsonls   = { "json", "jsonc" },
	marksman = { "md" },
	pyright  = { "python" },
	-- stylua: ignore end
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
				kubernetes = "*.yaml",
			},
		},
	},
}
vim.lsp.enable("yamlls")

-- ───────────────────────────< LUA >───────────────────────────

vim.lsp.config["lua_ls"] = {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = { { ".luarc.json", ".luarc.jsonc" }, ".git" },
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
