local handlers = require("scrollbar.handlers")

require("scrollbar").setup({
	handle = {
		blend = 40,
		text = " ",
		highlight = "CursorLine",
	},
	handlers = {
		diagnostic = false,
		gitsigns = false,
	},
	marks = {
		Cursor = {
			text = "🞙",
			highlight = "CursorLineNr",
		},
		Hint = {
			text = { "╍", "╍" },
			highlight = "ScrollbarHint",
		},
		Warn = {
			text = { "╍", "╍" },
			highlight = "ScrollbarWarn",
		},
		Info = {
			text = { "†", "†" },
			highlight = "ScrollbarInfo",
		},
		Error = {
			text = { "╍", "╍" },
			highlight = "ScrollbarError",
		},
	},
})

-- Palabras clave a buscar y su tipo de marca asociada
local keywords = {
	["FIX:"] = "Error",
	["FIXME:"] = "Error",
	["BUG:"] = "Error",
	["WARN:"] = "Warn",
	["TODO:"] = "Warn",
	["PEND:"] = "Info",
	["NOTE:"] = "Hint",
	["NOTA:"] = "Hint",
}

-- Cache que almacena las marcas encontradas por cada buffer
local todo_cache = {}

-- Escanea el buffer y busca palabras clave, returns lista de marcas
local function scan_buffer(bufnr)
	local marks = {}
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	-- Itera sobre cada linea del buffer
	for i, line in ipairs(lines) do
		-- Busca cada palabra clave en la linea
		for key, level in pairs(keywords) do
			if line:find(key, 1, true) then
				-- Agrega la marca con la linea (0-indexed) y su tipo
				marks[#marks + 1] = {
					line = i - 1,
					type = level,
				}
				break
			end
		end
	end

	-- Guarda las marcas en cache para ese buffer
	todo_cache[bufnr] = marks
end

-- Registra el handler personalizado "todo" para el scrollbar
handlers.register("todo", function(bufnr)
	return todo_cache[bufnr] or {}
end)

vim.api.nvim_create_autocmd({
	"BufEnter",
	"BufReadPost",
	"TextChanged",
	"TextChangedI",
	"BufWritePost",
}, {
	callback = function(args)
		scan_buffer(args.buf)
	end,
})

-- Limpia el cache cuando se elimina un buffer
vim.api.nvim_create_autocmd("BufDelete", {
	callback = function(args)
		todo_cache[args.buf] = nil
	end,
})

-- Escanea el buffer actual al iniciar Neovim
scan_buffer(0)
