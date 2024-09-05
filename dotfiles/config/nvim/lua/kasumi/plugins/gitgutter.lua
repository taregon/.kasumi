-- Configuración para vim-gitgutter en Lua
vim.g.gitgutter_sign_allow_clobber = 1
vim.g.gitgutter_sign_added = "󱐱"
vim.g.gitgutter_sign_modified = "󰴔"
vim.g.gitgutter_sign_removed = "󱐳" -- 󰯈
vim.g.gitgutter_set_sign_backgrounds = 1

-- Inicializa una variable global para rastrear si la ventana de diff está abierta
vim.g.gitgutter_diff_open = false

-- Define la función para alternar la ventana del diff
function GitGutterDiffOrigToggle()
	if not vim.g.gitgutter_diff_open then
		vim.cmd("GitGutterDiffOrig")
	else
		vim.cmd("close")
		vim.cmd("bdelete!")
	end
	vim.g.gitgutter_diff_open = not vim.g.gitgutter_diff_open
end

vim.api.nvim_set_keymap("n", "<F5>", ":lua GitGutterDiffOrigToggle()<CR>", { noremap = true, silent = true })
