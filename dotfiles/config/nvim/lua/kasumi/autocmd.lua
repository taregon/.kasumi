--  █████╗ ██╗   ██╗████████╗ ██████╗  ██████╗███╗   ███╗██████╗
-- ██╔══██╗██║   ██║╚══██╔══╝██╔═══██╗██╔════╝████╗ ████║██╔══██╗
-- ███████║██║   ██║   ██║   ██║   ██║██║     ██╔████╔██║██║  ██║
-- ██╔══██║██║   ██║   ██║   ██║   ██║██║     ██║╚██╔╝██║██║  ██║
-- ██║  ██║╚██████╔╝   ██║   ╚██████╔╝╚██████╗██║ ╚═╝ ██║██████╔╝
-- ╚═╝  ╚═╝ ╚═════╝    ╚═╝    ╚═════╝  ╚═════╝╚═╝     ╚═╝╚═════╝

-- ╒═══════════════════════════════════════════════════════════╕
-- │                        AUTO_GROUPS                        │
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

-- SEMÁNTICA DE NOMBRES
-- ────────────────────────────────────────────────────────────
-- Formato: PascalSnake_Case
-- Separadores por contexto:
--   ft_*     -> filetypes (ft_Ini_Syntax, ft_Csv_Filetypes)
--   cursor_* -> cursor (Cursor_Restore)
--   num_*    -> números (Num_Rel_Toggle)
--   *_*      -> acciones (Awk_Indent_Save, Lint_Auto, Fmt_On_Save)
--   *_Off    -> desactivación (Indent_Mini_Off, Spell_Off)
--   ts_*     -> treesitter (Ts_Start)
--   bash_*   -> bash (SortBashFunctions)

-- ╒═══════════════════════════════════════════════════════════╕
-- │                         FILETYPES                         │
-- ╘═══════════════════════════════════════════════════════════╛

-- Asigna sintaxis dosini a archivos conf e ini
augroup("Ft_Ini_Syntax", function(group)
	aucmd("BufReadPost", {
		group = group,
		pattern = { "*.conf", "*.ini" },
		command = "set syntax=dosini",
	})
end)

-- Asigna filetypes a CSV y DAT
augroup("Ft_Csv_Filetypes", function(group)
	aucmd({ "BufNewFile", "BufRead" }, {
		group = group,
		pattern = "*.csv",
		command = "set filetype=rfc_csv",
	})

	aucmd({ "BufNewFile", "BufRead" }, {
		group = group,
		pattern = "*.dat",
		command = "set filetype=csv_pipe",
	})
end)

-- Registra filetypes para archivos todo
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
augroup("Cursor_Restore", function(group)
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

-- Números relativos en modo Normal, desactivados en Insert y Visual
augroup("Num_Rel_Toggle", function(group)
	aucmd({ "BufEnter", "BufWinEnter" }, {
		group = group,
		callback = function()
			vim.opt.number = true
			vim.opt.relativenumber = true
		end,
	})

	-- Insertar modo -> desactivar números relativos
	aucmd("InsertEnter", {
		group = group,
		callback = function()
			vim.opt.relativenumber = false
		end,
	})

	-- Salir de Insert -> activar números relativos
	aucmd("InsertLeave", {
		group = group,
		callback = function()
			vim.opt.relativenumber = true
		end,
	})

	-- Entrar en modos Visual -> desactivar números relativos
	aucmd("ModeChanged", {
		group = group,
		pattern = "*:[vV\x16]*",
		callback = function()
			vim.opt.relativenumber = false
		end,
	})

	-- Salir de modos Visual -> activar números relativos si no está en Insert
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

-- Indenta archivos AWK al guardar
augroup("Awk_Indent_Save", function(group)
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
augroup("Lint_Auto", function(group)
	aucmd({ "BufEnter", "BufWritePost", "TextChanged" }, {
		group = group,
		callback = function()
			require("lint").try_lint()
		end,
	})
end)

-- Formatea con conform al guardar
augroup("Fmt_On_Save", function(group)
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
augroup("Indent_Mini_Off", function(group)
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

-- Desactiva spell en logs, txt y codecompanion
augroup("Spell_Off", function(group)
	aucmd({ "BufRead", "BufNewFile", "BufEnter", "BufWinEnter", "FileType" }, {
		group = group,
		pattern = { "*.log", "*.txt", "codecompanion" },
		command = "setlocal nospell",
	})
end)

-- ╒═══════════════════════════════════════════════════════════╕
-- │                           TOOLS                           │
-- ╘═══════════════════════════════════════════════════════════╛

-- Inicia Tree-sitter en cada buffer
augroup("Ts_Start", function(group)
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

-- ────────────────────────────────────────────────────────────
-- USER COMMAND: SortBashFunctions
-- Ordena funciones Bash alfabéticamente
local function get_bash_func_name(func_text)
	local name = func_text:match("^%s*function%s+([%w_]+)")
	if name then
		return name
	end
	name = func_text:match("^%s*([%w_]+)%s*%(%s*%)")
	return name
end

vim.api.nvim_create_user_command("SortBashFunctions", function(opts)
	local bufnr = vim.api.nvim_get_current_buf()
	local all_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	local start_line, end_line
	if opts.range and opts.range ~= 0 then
		start_line = opts.line1 - 1
		end_line = opts.line2
	else
		start_line = 0
		end_line = #all_lines - 1
	end

	local preamble = {}
	local funcs = {}
	local current_func = {}
	local inside_func = false
	local idx = 0

	for line in pairs(all_lines) do
		idx = idx + 1
		if idx - 1 < start_line then
			table.insert(preamble, line)
		elseif idx - 1 > end_line then
			break
		else
			local is_func_start = line:match("^%s*function%s+%w+") or line:match("^%s*([%w_]+)%s*%(%s*%)%s*{")

			if is_func_start then
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
	end

	if #current_func > 0 then
		table.insert(funcs, table.concat(current_func, "\n"))
	end

	if #funcs == 0 then
		vim.notify("No se detectaron funciones Bash en el rango seleccionado", vim.log.levels.WARN)
		return
	end

	table.sort(funcs, function(a, b)
		return (get_bash_func_name(a) or ""):lower() < (get_bash_func_name(b) or ""):lower()
	end)

	local sorted_lines = vim.split(table.concat(funcs, "\n") .. "\n", "\n")
	local new_lines = preamble
	for _, l in ipairs(sorted_lines) do
		table.insert(new_lines, l)
	end

	vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
	vim.notify("Funciones Bash ordenadas correctamente", vim.log.levels.INFO)
end, { range = true })
