-- ┌────────────────────────────────────────────────────┐
-- │░█▀▀░█▀█░█▀▄░█▀▀░█▀▀░█▀█░█▄█░█▀█░█▀█░█▀█░▀█▀░█▀█░█▀█│
-- │░█░░░█░█░█░█░█▀▀░█░░░█░█░█░█░█▀▀░█▀█░█░█░░█░░█░█░█░█│
-- │░▀▀▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀░░░▀░▀░▀░▀░▀▀▀░▀▀▀░▀░▀│
-- └────────────────────────────────────────────────────┘
-- Ayuda: https://raw.githubusercontent.com/olimorris/codecompanion.nvim/refs/heads/main/doc/codecompanion.txt
-- https://github.com/olimorris/codecompanion.nvim/blob/main/doc/getting-started.md
-- KEYMAPS: https://github.com/olimorris/codecompanion.nvim/blob/main/doc/configuration/chat-buffer.md#keymaps
-- DOCUMENTACIÓN PRINCIPAL: https://codecompanion.nvim.ai/

local ok, codecompanion = pcall(require, "codecompanion")
if not ok then
	vim.notify("codecompanion.nvim no encontrado. Verifica instalación.", vim.log.levels.ERROR)
	return
end

codecompanion.setup({
	adapters = {
		http = {
			ministral = function()
				return require("codecompanion.adapters").extend("ollama", {
					name = "Ministral-3B",
					-- stylua: ignore
					schema = {
						model          = { default = "ministral-3:3b" },
						num_ctx        = { default = 8192 },
						num_predict    = { default = 400 },
						repeat_penalty = { default = 1.12 },
						temperature    = { default = 0.15 },
						top_p          = { default = 0.75 },
						top_k          = { default = 44 },
					},
					env = { url = "http://127.0.0.1:11434" },
				})
			end,

			gemma = function()
				return require("codecompanion.adapters").extend("ollama", {
					name = "Gemma-4",
					-- stylua: ignore
					schema = {
						model          = { default = "gemma4:e2b" },
						num_ctx        = { default = 8192 },
						num_predict    = { default = 400 },
						repeat_penalty = { default = 1.11 },
						temperature    = { default = 0.14 },
						top_p          = { default = 0.95 },
						top_k          = { default = 64 },
					},
					env = { url = "http://127.0.0.1:11434" },
				})
			end,

			-- think en schema (no en parameters): el adapter Ollama reconstruye
			-- self.parameters.think desde el default del schema
			-- (check_thinking_capability), sobrescribiendo parameters estatico.
			gemma_it = function()
				return require("codecompanion.adapters").extend("ollama", {
					name = "Gemma-4-it",
					-- stylua: ignore
					schema = {
						model          = { default = "gemma4:e2b-it-qat" },
						think          = { default = false },
						num_ctx        = { default = 8192 },
						num_predict    = { default = 512 },
						repeat_penalty = { default = 1.10 },
						temperature    = { default = 0.38 },
						top_p          = { default = 0.84 },
						top_k          = { default = 40 },
					},
					env = { url = "http://127.0.0.1:11434" },
				})
			end,

			qwen3 = function()
				return require("codecompanion.adapters").extend("ollama", {
					name = "Qwen-3-it",
					-- stylua: ignore
					schema = {
						-- Qwen3-4B-Instruct-2507 (Q4_K_M)
						-- Sitio oficial: https://huggingface.co/Jeney
						model          = { default = "hf.co/Jeney/Qwen3-4B-Instruct-2507-GGUF:Q4_K_M" },
						num_ctx        = { default = 8192 },
						num_predict    = { default = 512 },
						repeat_penalty = { default = 1.02 },
						temperature    = { default = 0.76 },
						top_p          = { default = 0.94 },
						top_k          = { default = 40 },
					},
					env = { url = "http://127.0.0.1:11434" },
				})
			end,

			opts = { show_presets = false },
		},
	},
	-- NOTA: Los tipos de interacciones válidos son: chat, inline, cmd, background
	-- "strategies" fue renombrado a "interactions" en versiones recientes
	-- stylua: ignore
	interactions = {
		chat   = { adapter = "gemma_it" },
		inline = { adapter = "gemma_it" },
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
	opts = {
		log_level = "TRACE", -- Almacenado en: ~/.local/state/nvim/codecompanion.log
	},
	prompt_library = {
		markdown = {
			dirs = {
				vim.fn.stdpath("config") .. "/lua/kasumi/plugins/ai/prompts",
			},
		},
	},
})

-- Keymaps
-- Según la documentación oficial, se recomienda:
-- <C-a> para CodeCompanionActions (acción recomendada)
-- <LocalLeader>a para CodeCompanionChat Toggle
-- Más info: https://codecompanion.nvim.ai/getting-started#suggested-workflow
vim.keymap.set({ "n", "v" }, "<leader>oc", "<cmd>CodeCompanion<CR>", { desc = "Abrir chat AI" })
vim.keymap.set("n", "<leader>og", "<cmd>CodeCompanionActions<CR>", { desc = "Acciones AI" })
