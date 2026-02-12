---@diagnostic disable: unused-local
return {
	staged_diff = function(args)
		local result = vim.system({
			"git",
			"diff",
			"--no-ext-diff",
			"--staged",
		}, { text = true }):wait()

		if result.code ~= 0 then
			return "Error al obtener diff staged."
		end

		local diff = result.stdout or ""
		if diff == "" then
			return "No hay cambios staged."
		end

		return diff
	end,
}
