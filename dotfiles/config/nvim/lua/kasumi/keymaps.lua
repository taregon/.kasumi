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

-- Muestra / oculta caracteres especiales
map("n", "<Leader>i", ":set invlist<CR>")

-- Muestra el panel de navegación
map("n", "<leader>n", ":Neotree toggle reveal<CR>")
map("n", "<leader>b", ":Neotree buffers<CR>")

-- Cierra el buffer actual .sin guardar!
map("n", "<leader>d", ":bd<cr>")

-- Desactivar el resaltado de búsqueda actual.
map("n", "<leader>/", ":nohl<cr>")

-- Dividir ventana
map("n", "-", ":new<cr>")
map("n", "|", ":vnew<cr>")

-- Cambiar entre buffers
map("n", "<Tab>", "<cmd>bnext<cr>")
map("n", "<S-Tab>", "<cmd>bprev<cr>")

-- Cambiar entre ventanas
map("n", "<C-h>", "<C-w>h") -- Izquierda
map("n", "<C-j>", "<C-w>j") -- Abajo
map("n", "<C-k>", "<C-w>k") -- Arriba
map("n", "<C-l>", "<C-w>l") -- Derecha

-- quick fix
map("n", "<leader>q", ":copen<cr>")

-- Función para realizar la búsqueda y copiar el texto seleccionado
map("x", "//", 'y/<C-R>"<cr>')

-- Vista previa de Markdown
map("n", "<leader>md", ":MarkdownPreviewToggle<cr>", { desc = "Markdown Preview Toggle" })

--  __         __
-- |  |_.-----|  .-----.-----.----.-----.-----.-----.
-- |   _|  -__|  |  -__|__ --|  __|  _  |  _  |  -__|
-- |____|_____|__|_____|_____|____|_____|   __|_____|
--                                      |__|
--
local builtin = require("telescope.builtin")

map("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
map("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
-- map("n", "<leader>ff", function()
-- 	builtin.find_files({ cwd = "~/.config/" })
-- end, { desc = "Telescope find files en un directorio específico" })

-- map("n", "<leader>fg", builtin.grep_string, { desc = "Telescope grep" })
map("n", "<leader>fh", builtin.help_tags, { desc = "Telescope help tags" })
map("n", "<leader>fl", builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set("n", "<leader>fs", require("telescope").extensions.live_grep_args.live_grep_args, { noremap = true })
-- map("n", "<leader>ss", require("utils").spell_check, { desc = "Telescope spell check" })
