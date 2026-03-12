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
						-- Elige el modelo de IA que se cargará al inicio
						model          = { default = "ministral-3:3b" },
						-- Define cuánta memoria tiene la IA para recordar el chat y el código actual
						num_ctx        = { default = 8192 },
						-- Limita la longitud máxima de la respuesta para evitar textos infinitos
						-- Con -1, el modelo no para hasta que él mismo decide que ha terminado
						-- o hasta que se llena el contexto
						num_predict    = { default = 512 },
						-- Evita que la IA se quede trabada repitiendo las mismas frases una y otra vez
						repeat_penalty = { default = 1.1 },
						-- Controla la "locura" de la IA: 0.1 es serio y preciso, 1.0 es creativo y variado
						temperature    = { default = 0.35 },
						-- Prioriza las palabras más lógicas para que la IA no pierda el hilo técnico
						top_p          = { default = 0.5 },
					},
					env = { url = "http://127.0.0.1:11434" },
					-- headers = { ["Content-Type"] = "application/json" },
				})
			end,
			opts = { show_presets = false },
			-- parameters = { sync = true },
		},
	},
	-- NOTA: Los tipos de interacciones válidos son: chat, inline, cmd, background
	-- "strategies" fue renombrado a "interactions" en versiones recientes
	-- stylua: ignore
	interactions = {
		-- agent NO es una interacción válida
		chat   = { adapter = "ministral" },
		inline = { adapter = "ministral" },
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
