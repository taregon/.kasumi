-- ┌────────────────────────────────────────────────────┐
-- │░█▀▀░█▀█░█▀▄░█▀▀░█▀▀░█▀█░█▄█░█▀█░█▀█░█▀█░▀█▀░█▀█░█▀█│
-- │░█░░░█░█░█░█░█▀▀░█░░░█░█░█░█░█▀▀░█▀█░█░█░░█░░█░█░█░█│
-- │░▀▀▀░▀▀▀░▀▀░░▀▀▀░▀▀▀░▀▀▀░▀░▀░▀░░░▀░▀░▀░▀░▀▀▀░▀▀▀░▀░▀│
-- └────────────────────────────────────────────────────┘
-- Ayuda: https://raw.githubusercontent.com/olimorris/codecompanion.nvim/refs/heads/main/doc/codecompanion.txt
-- https://github.com/olimorris/codecompanion.nvim/blob/45537d82516c9a7bf4c15a5c9bbeb82fb60f415b/doc/configuration/system-prompt.md#L4
-- De lo anterior puedes buscar: KEYMAPS
-- https://github.com/olimorris/codecompanion.nvim/blob/main/doc/getting-started.md

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
						-- Elige el modelo de IA que se cargará al inicio
						model          = { default = "gemma2:2b" },
						-- Define cuánta memoria tiene la IA para recordar el chat y el código actual
						num_ctx        = { default = 4096 },
						-- Limita la longitud máxima de la respuesta para evitar textos infinitos
                        -- Con -1, el modelo no para hasta que él mismo decide que ha terminado
                        -- o hasta que se llena el contexto
						num_predict    = { default = 1024 },
						-- Evita que la IA se quede trabada repitiendo las mismas frases una y otra vez
						repeat_penalty = { default = 1.1 },
						-- Controla la "locura" de la IA: 0.1 es serio y preciso, 1.0 es creativo y variado
						temperature    = { default = 0.3 },
						-- Prioriza las palabras más lógicas para que la IA no pierda el hilo técnico
						top_p          = { default = 0.4 },
					},
					env = { url = "http://127.0.0.1:11434" },
					-- headers = { ["Content-Type"] = "application/json" },
				})
			end,
			opts = { show_presets = false },
			-- parameters = { sync = true },
		},
	},
    -- WARN: Strategies es el término antiguo que fue renombrado a interactions
    -- y puede aparecer en ejemplos o configuraciones heredadas.
    -- stylua: ignore
	interactions = {
		agent  = { adapter = "ollamaAnna" },
		chat   = { adapter = "ollamaAnna" },
		inline = { adapter = "ollamaAnna" },
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
		log_level = "DEBUG", -- Almacenado en: ~/.local/state/nvim/codecompanion.log
		language = "Spanish (neutral, technical)",
	},
	prompt_library = {
		markdown = {
			dirs = {
				vim.fn.stdpath("config") .. "/lua/kasumi/plugins/ai/prompts",
			},
		},
	},
})

-- Keymaps (agrega donde tengas tus mappings)
vim.keymap.set({ "n", "v" }, "<leader>oc", "<cmd>CodeCompanion<CR>", { desc = "Abrir chat AI" })
vim.keymap.set("n", "<leader>og", "<cmd>CodeCompanionActions<CR>", { desc = "Acciones AI" })
