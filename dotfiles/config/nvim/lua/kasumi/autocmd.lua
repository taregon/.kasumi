--  █████╗ ██╗   ██╗████████╗ ██████╗  ██████╗███╗   ███╗██████╗
-- ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝████╗ ████║██╔══██╗
-- ███████║██║   ██║   ██║   ██║   ██║██║     ██╔████╔██║██║  ██║
-- ██╔══██║██║   ██║   ██║   ██║   ██║██║     ██║╚██╔╝██║██║  ██║
-- ██║  ██║╚██████╔╝   ██║   ╚██████╔╝╚██████╗██║ ╚═╝ ██║██████╔╝
-- ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝  ╚═════╝╚═╝     ╚═╝╚═════╝

-- ╒═══════════════════════════════════════════════════════════╕
-- │                         METADATA                          │
-- ╘═══════════════════════════════════════════════════════════╛

-- Simplifica la llamada al método de creación de auto comandos
local aucmd = vim.api.nvim_create_autocmd

-- Función para crear y configurar grupos de auto comandos
-- @param name string nombre del grupo de autocomandos
-- @param fn function función que define los autocomandos dentro del grupo
local function augroup(name, fn)
	local group = vim.api.nvim_create_augroup(name, { clear = true })
	fn(group)
end

-- ╒═══════════════════════════════════════════════════════════╕
-- │                         FILETYPES                         │
-- ╘═══════════════════════════════════════════════════════════╛

-- Configuración de archivos INI
augroup("Ini_Files", function(group)
	aucmd("BufReadPost", {
		group = group,
		pattern = { "*.conf", "*.ini" },
		command = "set syntax=dosini",
	})
end)

-- Configuración de archivos CSV y DAT
augroup("CsvFileTypes", function(group)
	-- Manejo de archivos CSV
	aucmd({ "BufNewFile", "BufRead" }, {
		group = group,
		pattern = "*.csv",
		command = "set filetype=rfc_csv",
	})

	-- Manejo de archivos DAT
	aucmd({ "BufNewFile", "BufRead" }, {
		group = group,
		pattern = "*.dat",
		command = "set filetype=csv_pipe",
	})
end)

-- Registro estático de filetypes personalizados
vim.filetype.add({
	extension = { ["todo.txt"] = "todotxt" },
	filename = {
		["todo.txt"] = "todotxt",
		["done.txt"] = "todotxt",
		["report.txt"] = "todotxt",
	},
})

-- ╒═══════════════════════════════════════════════════════════╕
-- │                         EDITOR UX                         │
-- ╘═══════════════════════════════════════════════════════════╛

-- Recuerda la última posición del cursor
augroup("RestoreCursor", function(group)
	aucmd("BufReadPost", {
		group = group,
		pattern = "*",
		callback = function()
			local last_line = vim.fn.line("'\"")
			if last_line > 1 and last_line <= vim.fn.line("$") then
				vim.cmd('normal! g`"')
			end
		end,
	})
end)

-- Alterna números relativos según el modo
-- Números relativos activados en Normal, desactivados en Insert y Visual
augroup("ToggleRelativeNumber", function(group)
	-- Al abrir un buffer, activar números relativos por defecto
	aucmd({ "BufEnter", "BufWinEnter" }, {
		group = group,
		callback = function()
			vim.opt.number = true
			vim.opt.relativenumber = true
		end,
	})

	-- Insertar modo → desactivar números relativos
	aucmd("InsertEnter", {
		group = group,
		callback = function()
			vim.opt.relativenumber = false
		end,
	})

	-- Salir de Insert → activar números relativos
	aucmd("InsertLeave", {
		group = group,
		callback = function()
			vim.opt.relativenumber = true
		end,
	})

	-- Entrar en modos Visual → desactivar números relativos
	aucmd("ModeChanged", {
		group = group,
		pattern = "*:[vV\x16]*",
		callback = function()
			vim.opt.relativenumber = false
		end,
	})

	-- Salir de modos Visual → activar números relativos si no está en Insert
	aucmd("ModeChanged", {
		group = group,
		pattern = "[vV\x16]*:*",
		callback = function()
			if vim.fn.mode():match("i") then
				return
			end
			vim.opt.relativenumber = true
		end,
	})
end)

-- Auto-indentación y limpieza de archivos AWK al guardar
augroup("AwkIndent", function(group)
	aucmd("BufWritePre", {
		group = group,
		pattern = "*.awk",
		callback = function()
			vim.cmd("normal! gg=G")
		end,
	})
end)

-- ╒═══════════════════════════════════════════════════════════╕
-- │                       FORMAT & LINT                       │
-- ╘═══════════════════════════════════════════════════════════╛

-- Ejecuta linters automáticamente
augroup("NvimLint", function(group)
	-- Eventos optimizados para el linter
	aucmd({ "BufEnter", "BufWritePost", "TextChanged" }, {
		group = group,
		callback = function()
			require("lint").try_lint()
		end,
	})
end)

-- Ejecutar automáticamente los formatters configurados al guardar
augroup("FormatOnSave", function(group)
	aucmd("BufWritePre", {
		group = group,
		pattern = "*",
		callback = function(args)
			require("conform").format({ bufnr = args.buf })
		end,
	})
end)

-- ╒═══════════════════════════════════════════════════════════╕
-- │                      DISABLE PLUGINS                      │
-- ╘═══════════════════════════════════════════════════════════╛

-- Deshabilita mini.indentscope en buffers donde no aporta valor
augroup("DisableMiniIndentScope", function(group)
	aucmd("FileType", {
		group = group,
		pattern = {
			"TelescopePrompt",
			"TelescopeResults",
			"codecompanion",
			"conf",
			"help",
			"markdown",
			"text",
		},
		callback = function()
			vim.b.miniindentscope_disable = true
		end,
	})
end)

-- Desactivar spell / corrector ortográfico
augroup("NoSpell", function(group)
	aucmd({ "BufRead", "BufNewFile", "BufEnter", "BufWinEnter", "FileType" }, {
		group = group,
		pattern = { "*.log", "*.txt", "codecompanion" },
		command = "setlocal nospell",
	})
end)

-- ╒═══════════════════════════════════════════════════════════╕
-- │                           TOOLS                           │
-- ╘═══════════════════════════════════════════════════════════╛

-- Activa Tree-sitter en buffers abiertos
augroup("TreesitterStart", function(group)
	aucmd("FileType", {
		group = group,
		callback = function(args)
			local buf = args.buf
			local ft = vim.bo[buf].filetype

			local lang = vim.treesitter.language.get_lang(ft)
			if not lang then
				return
			end

			pcall(vim.treesitter.start, buf, lang)
		end,
	})
end)

-- Ordena funciones en Bash alfabéticamente
augroup("BashSortF", function(group)
	aucmd("FileType", {
		group = group,
		pattern = { "sh", "bash" },
		callback = function()
			vim.api.nvim_create_user_command("SortBashFunctions", function(opts)
				local start_line, end_line
				local bufnr = vim.api.nvim_get_current_buf()
				if opts.range and opts.range ~= 0 then
					start_line = opts.line1 - 1
					end_line = opts.line2
				else
					start_line = 0
					end_line = vim.api.nvim_buf_line_count(bufnr)
				end

				local lines = vim.api.nvim_buf_get_lines(bufnr, start_line, end_line, false)

				local funcs = {}
				local current_func = {}
				local inside_func = false

				for i, line in ipairs(lines) do
					if line:match("^%s*function%s+%w+") or line:match("^%s*[%w_]+%s*%(%s*%)%s*{") then
						if inside_func then
							table.insert(funcs, table.concat(current_func, "\n"))
							current_func = {}
						end
						inside_func = true
					end

					if inside_func then
						table.insert(current_func, line)
					end
				end

				if #current_func > 0 then
					table.insert(funcs, table.concat(current_func, "\n"))
				end

				if #funcs == 0 then
					vim.notify("No se detectaron funciones Bash en el rango seleccionado", vim.log.levels.WARN)
					return
				end

				table.sort(funcs, function(a, b)
					local name_a = a:match("^%s*function%s+([%w_]+)")
					if not name_a then
						name_a = a:match("^%s*([%w_]+)%s*%(%s*%)")
					end
					local name_b = b:match("^%s*function%s+([%w_]+)")
					if not name_b then
						name_b = b:match("^%s*([%w_]+)%s*%(%s*%)")
					end
					return (name_a or ""):lower() < (name_b or ""):lower()
				end)

				local new_lines = {}
				for _, f in ipairs(funcs) do
					local func_lines = vim.split(f, "\n")
					for _, l in ipairs(func_lines) do
						table.insert(new_lines, l)
					end
					table.insert(new_lines, "")
				end

				vim.api.nvim_buf_set_lines(bufnr, start_line, end_line, false, new_lines)
				vim.notify("Funciones Bash ordenadas correctamente", vim.log.levels.INFO)
			end, { range = true })
		end,
	})
end)
