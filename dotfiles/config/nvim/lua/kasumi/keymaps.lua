-- Para verificar la tecla líder
-- :echo mapleader
-- :verbose map <Leader>

-- Facilita el mapeo de teclas personalizado, con opciones adicionales.
local function map(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.api.nvim_set_keymap(mode, lhs, rhs, options)
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

-- quick fix
map("n", "<space>q", ":copen<cr>")
map("n", "<space>Q", ":cclose<cr>")

-- Copia el texto seleccionado al porta papeles del sistema en modo visual
map("v", "<leader>y", '"+y')
-- Función para realizar la búsqueda y copiar el texto seleccionado
map("x", "//", 'y/<C-R>"<cr>')

-- vim.g.maplocalleader = ","

-- vim.api.nvim_set_keymap("n", "Y", "y$", { noremap = true })

-- vim.api.nvim_set_keymap("n", "<localleader>", ":<C-u>WhichKey ','<CR>", { noremap = true, silent = true })

-- vim.keymap.set("n", "<leader>l", function()
-- 	lint.try_lint()
-- end, { desc = "Trigger linting for current file" })

-- map("n", "<leader>s", ":write<CR>", { noremap = true, silent = true }, { desc = "Guardar" })
-- map("n", "<leader>", ":<C-u>WhichKey '\\'<CR>", { noremap = true, silent = true })
