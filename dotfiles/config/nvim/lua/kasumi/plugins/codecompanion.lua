-- Ayuda: https://raw.githubusercontent.com/olimorris/codecompanion.nvim/refs/heads/main/doc/codecompanion.txt

local ok, codecompanion = pcall(require, "codecompanion")
if not ok then
	vim.notify("codecompanion.nvim no encontrado. Verifica instalación.", vim.log.levels.ERROR)
	return
end

codecompanion.setup({
	adapters = {
		http = {
			ollamaAnna = function()
				return require("codecompanion.adapters").extend("ollama", {
					name = "ollamaAnna",
                    -- stylua: ignore
					schema = {
						model       = { default = "gemma2:2b" },
						num_ctx     = { default = 4096 },
						temperature = { default = 0.35 },
						top_p       = { default = 0.9 },
                        num_predict = { default = -1 },
					},
					env = { url = "http://127.0.0.1:11434" },
					-- headers = { ["Content-Type"] = "application/json" },
				})
			end,
			opts = { show_presets = false },
			-- parameters = { sync = true },
		},
	},
	display = {
		chat = {
			window = {
				layout = "vertical",
				width = 0.4,
			},
		},
		diff = {
			enabled = true,
			provider = "split", -- Cambia a "mini_diff" si instalas mini.diff
			layout = "vertical",
			opts = {
				"algorithm:patience",
				"closeoff",
				"filler",
				"followwrap",
				"internal",
				"linematch:120",
			},
		},
	},
	interactions = {
		chat = {
			tools = { enabled = false }, -- ligereza
			slash_commands = {
				["commit"] = true, -- /commit genera del staged diff
				["buffer"] = true,
			},
		},
	},
	strategies = {
		chat = { adapter = "ollamaAnna" },
		inline = { adapter = "ollamaAnna" },
		agent = { adapter = "ollamaAnna" },
	},

Reglas estrictas:
- Formato: tipo(scope opcional): descripción corta en imperativo presente.
- Tipos válidos: feat, fix, refactor, docs, style, test, chore, perf, ci, build, revert.
- Scope: opcional, minúsculas (ej. auth, ui, api).
- Descripción: ≤60 chars, verbo imperativo (add, fix, update...).
- Breaking change: feat! o fix! etc.
- Analiza SOLO git diff --cached.

Ejemplos:
feat: add login handler
fix(ui): correct button alignment
chore(deps): update neovim deps

Responde SOLO el mensaje.
]]
			end
			return "You are a helpful AI assistant."
		end,
	},
})

-- Keymaps (agrega donde tengas tus mappings)
vim.keymap.set({ "n", "v" }, "<leader>oc", "<cmd>CodeCompanion<CR>", { desc = "Abrir chat AI" })
vim.keymap.set("n", "<leader>og", "<cmd>CodeCompanionActions<CR>", { desc = "Acciones AI" })
