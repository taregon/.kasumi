-- Helper para el prompt "Commit en Español"
-- Proporciona la función staged_diff que devuelve el git diff --cached
---@diagnostic disable: unused-local

return {
	staged_diff = function(args)
		local root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
		if vim.v.shell_error ~= 0 or root == "" then
			return "Error: No se detectó un repositorio Git válido."
		end

		local file = vim.fn.expand("%:p")
		if file == "" then
			return "Error: No hay archivo abierto en el buffer actual."
		end

		local cmd = "cd "
			.. vim.fn.shellescape(root)
			.. " && git diff --cached --no-ext-diff -- "
			.. vim.fn.shellescape(file)
		local diff = vim.fn.system(cmd)

		return (diff == "" or vim.v.shell_error ~= 0) and "No hay cambios staged en este archivo" or diff
	end,
}
