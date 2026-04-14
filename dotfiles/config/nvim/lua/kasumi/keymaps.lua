-- ██╗  ██╗███████╗██╗   ██╗███╗   ███╗ █████╗ ██████╗ ███████╗
-- ██║ ██╔╝██╔════╝╚██╗ ██╔╝████╗ ████║██╔══██╗██╔══██╗██╔════╝
-- █████╔╝ █████╗   ╚████╔╝ ██╔████╔██║███████║██████╔╝███████╗
-- ██╔═██╗ ██╔══╝    ╚██╔╝  ██║╚██╔╝██║██╔══██║██╔═══╝ ╚════██║
-- ██║  ██╗███████╗   ██║   ██║ ╚═╝ ██║██║  ██║██║     ███████║
-- ╚═╝  ╚═╝╚══════╝   ╚═╝   ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝     ╚══════╝

-- Para verificar la tecla líder
-- :echo mapleader
-- :verbose map <Leader>

-- Facilita el mapeo de teclas personalizado, con opciones adicionales.
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- ────────────────────────────────────────────────────────────
-- Numerar líneas en un bloque visual con <leader>n
map("v", "<leader>n", function()
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")
	for i = start_line, end_line do
		local line = vim.fn.getline(i)
		local num = i - start_line + 1
		vim.api.nvim_buf_set_lines(0, i - 1, i, false, { num .. ". " .. line })
	end
end)

-- ────────────────────────────────────────────────────────────
-- Muestra el panel de navegación
-- map("n", "<leader>n", ":Neotree toggle reveal<CR>")
-- map("n", "<leader>b", ":Neotree buffers<CR>")

-- Numerar líneas en un bloque visual con <leader>n
-- map("v", "<leader>n", function()
-- 	vim.cmd([[:'<,'>s/^/\=line('.')-line("'<")+1 . '. '/]])
-- end)

-- Dividir ventana
-- map("n", "-", ":new<cr>")
-- map("n", "|", ":vnew<cr>")

-- ────────────────────────────────────────────────────────────
-- Elimina mappings nativos de Neovim definidos en vim/_defaults.lua
-- para evitar solapamientos y mantener control total de los atajos
vim.keymap.del("n", "gc")
vim.keymap.del("n", "gcc")
vim.keymap.del("x", "gc")
vim.keymap.del("o", "gc")

-- ────────────────────────────────────────────────────────────
-- Cierra el buffer actual .sin guardar!
map("n", "<leader>x", ":bd<cr>", { desc = "Close Buffer" })

-- Desactivar el resaltado de búsqueda actual.
map("n", "<leader>/", ":nohl<cr>")

-- Cambiar entre buffers
map("n", "<Tab>", "<cmd>bnext<cr>")
map("n", "<S-Tab>", "<cmd>bprev<cr>")

-- Cambiar entre ventanas
map("n", "<C-h>", "<C-w>h") -- Izquierda
map("n", "<C-j>", "<C-w>j") -- Abajo
map("n", "<C-k>", "<C-w>k") -- Arriba
map("n", "<C-l>", "<C-w>l") -- Derecha

-- Alterna la visualización de render-markdown.
local function toggle_render_markdown()
	vim.cmd("RenderMarkdown toggle")
	vim.cmd("Gitsigns toggle_signs")
	vim.cmd("set cursorline!")
	vim.cmd("set invlist!")
	vim.cmd("set invrelativenumber!")
	vim.cmd("set invnumber!")
end

map("n", "<F6>", toggle_render_markdown)

-- ────────────────────────────────────────────────────────────
-- █  ▄▀ █▀▀▀▀ █   █ █▀▀▀▀ █   █ █▄  █ ▄▀▀▀▀ ▄▀▀▀▀
-- █▀▀▄  █▀▀   ▀▀▀▀█ █▀▀   █   █ █ ▀▄█ █      ▀▀▀▄
-- ▀   ▀ ▀▀▀▀▀ ▀▀▀▀▀ ▀      ▀▀▀  ▀   ▀  ▀▀▀▀ ▀▀▀▀
-- Funciones auxiliares para atajos personalizados.
-- Estas funciones son invocadas desde which-key

local M = {}

-- TODOs del directorio actual
function M.show_todos_dir()
	local dir = vim.fn.expand("%:p:h")
	vim.cmd("TodoQuickFix cwd=" .. vim.fn.fnameescape(dir))
end

-- TODOs del archivo actual
function M.show_todos_file()
	local file = vim.fn.expand("%:p")
	vim.cmd("TodoQuickFix cwd=" .. vim.fn.fnameescape(file))
end

-- Abre un vsplit de Kitty en el directorio del archivo actual.
function M.vsplit_in_bufdir()
	local dir = vim.fn.expand("%:p:h")
	local cmd =
		string.format("silent !kitty @ launch --type=window --location=vsplit --cwd=%s", vim.fn.shellescape(dir))
	vim.cmd(cmd)
end

return M
