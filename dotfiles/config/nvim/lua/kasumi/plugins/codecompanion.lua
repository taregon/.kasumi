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
    -- Strategies es el término antiguo que fue renombrado a interactions
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
	interactions = {
		chat = {
			tools = { enabled = false }, -- ligereza
			slash_commands = {
				["commit"] = true, -- /commit genera del staged diff
				["buffer"] = true,
			},
		},
	},
    -- Strategies es el término antiguo que fue renombrado a interactions
    -- y puede aparecer en ejemplos o configuraciones heredadas.
    -- stylua: ignore
	interactions = {
		agent  = { adapter = "ollamaAnna" },
		chat   = { adapter = "ollamaAnna" },
		inline = { adapter = "ollamaAnna" },
	},

	prompt_library = {
		["Commit en Español"] = {
			interaction = "chat", -- Anteriormente: strategy
			description = "Genera un mensaje de commit en español (Conventional Commits)",
			opts = {
				alias = "ce",
				is_slash_cmd = true,
				auto_submit = true,
				contains_code = true,
				ignore_system_prompt = true,
			},
			prompts = {
				{
					role = "system",
					content = [[
Eres un experto en Conventional Commits (especificación 1.0.0). Genera mensajes de commit profesionales en español.

Estructura obligatoria:
1. TÍTULO (primera línea):
   - Formato: tipo[ámbito opcional]: descripción corta en imperativo español
   - Tipos válidos: feat, fix, refactor, docs, style, test, chore, perf, ci, build, revert
   - Descripción: verbo imperativo (agregar, corregir, actualizar, eliminar, refactorizar, documentar...)
   - Máximo 60 caracteres aprox.
   - Sin punto final
   - Breaking change: usa ! después del tipo (ej. feat!: ...)

2. Línea en blanco después del título

3. CUERPO (explica qué cambió y por qué, envuelto a ~72 caracteres por línea)

4. Línea en blanco (si hay footer)

5. FOOTER opcional:
   - BREAKING CHANGE: descripción
   - Refs #123, Closes #456, etc. (si se infiere del diff o contexto)

Reglas estrictas:
- Todo el mensaje en español (excepto los tipos como feat/fix)
- Responde SOLO con el mensaje de commit completo (sin texto adicional, sin markdown, sin "Aquí tienes", sin explicaciones)
- No inventes nada que no esté en el diff
- Si el cambio es trivial, el cuerpo puede ser breve o de 1-2 líneas
]],
				},
				{
					role = "user",
					content = function()
						-- Obtiene el root del repo automáticamente
						local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
						if vim.v.shell_error ~= 0 or root == "" then
							return "Error: No se detectó un repositorio Git válido. Asegúrate de estar dentro de un repo."
						end

						-- Ejecuta git diff desde el root
						local diff_cmd = "cd " .. vim.fn.shellescape(root) .. " && git diff --cached --no-ext-diff"
						local diff = vim.fn.system(diff_cmd)

						if diff == "" then
							return "No hay cambios staged (git add primero)."
						end

						return [[
Genera UN mensaje de commit completo en español basado SOLO en estos cambios staged:
```diff
                        ]] .. diff .. [[
```
Responde SOLO con el mensaje (título + cuerpo + footer si aplica).
Ejemplos válidos:
feat: agregar validación de correo en formulario de registro
Agrega chequeo de formato de email con regex antes de enviar al backend.
Previene errores tempranos y mejora la experiencia del usuario.
BREAKING CHANGE: el endpoint ahora rechaza correos inválidos con código 400
fix(auth): corregir manejo de token expirado en middleware
Revisa la expiración del JWT en cada request protegido.
Retorna 401 si el token ha expirado.
Anteriormente solo fallaba durante el refresh.
                        ]]
					end,
				},
			},
		},
	},
})

-- Keymaps (agrega donde tengas tus mappings)
vim.keymap.set({ "n", "v" }, "<leader>oc", "<cmd>CodeCompanion<CR>", { desc = "Abrir chat AI" })
vim.keymap.set("n", "<leader>og", "<cmd>CodeCompanionActions<CR>", { desc = "Acciones AI" })
