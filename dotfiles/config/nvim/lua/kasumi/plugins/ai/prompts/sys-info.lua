-- Obtiene un bloque de contexto del sistema usando fastfetch (--format json).
-- El resultado se devuelve como texto plano, estructurado y estable,
-- optimizado para ser inyectado como contexto en prompts de LLM
-- Si fastfetch o algún campo no está disponible, se usa "unknown".
--
-- Si cargas el archivo desde el init, puedes probar con:
-- :lua print(require("system_info").get_system_info_block())

local M = {}

local UNKNOWN = "unknown"

local function run_fastfetch()
	local output = vim.fn.systemlist({ "fastfetch", "--format", "json" })
	if vim.v.shell_error ~= 0 or not output or #output == 0 then
		return nil
	end

	local ok, data = pcall(vim.json.decode, table.concat(output, "\n"))
	if not ok then
		return nil
	end

	return data
end

local function find_block(data, block_type)
	for _, item in ipairs(data) do
		if item.type == block_type and item.result then
			return item.result
		end
	end
	return nil
end

function M.get_system_info_block()
	local data = run_fastfetch()
	if not data then
		return "[System]\nOS=unknown"
	end
    -- stylua: ignore start
	local base          = find_block(data, "OS") or {}
	local kernel        = find_block(data, "Kernel") or {}
	local wm            = find_block(data, "WM") or {}
	local cpu           = find_block(data, "CPU") or {}
	local mem           = find_block(data, "Memory") or {}
	local gpus          = find_block(data, "GPU") or {}

	local distro        = base.prettyName or UNKNOWN
	local arch          = kernel.architecture or UNKNOWN
	local kern          = kernel.release or UNKNOWN

	local wm_name       = wm.prettyName or UNKNOWN
	local cores         = cpu.cores and cpu.cores.logical or UNKNOWN
	-- stylua: ignore end

	-- HACE LA CONVERSION A GB
	local mem_gb = UNKNOWN
	if mem.total then
		mem_gb = tostring(math.floor(mem.total / 1024 / 1024 / 1024 + 0.5))
	end

	-- LISTAS TODAS LAS GPUS
	local gpu = UNKNOWN
	if type(gpus) == "table" and #gpus > 0 then
		local names = {}
		for _, g in ipairs(gpus) do
			if g.name then
				if g.type then
					table.insert(names, string.format("%s (%s)", g.name, g.type))
				else
					table.insert(names, g.name)
				end
			end
		end
		if #names > 0 then
			gpu = table.concat(names, ", ")
		end
	end

	-- ESTA FUNCIÓN SOLO IMPRIME LA PRIMERA GPU
	-- local gpu = UNKNOWN
	-- if type(gpus) == "table" and gpus[1] and gpus[1].name then
	-- 	gpu = gpus[1].name
	-- end

	local v = vim.version()
	local nvim = string.format("%d.%d.%d", v.major, v.minor, v.patch)

	return table.concat({
		"[System]",
		"Distro=" .. distro,
		"Kernel=" .. kern,
		"Arch=" .. arch,
		"",
		"[Environment]",
		"WM=" .. wm_name,
		"Neovim=" .. nvim,
		"",
		"[Hardware]",
		"CPU_Cores=" .. cores,
		"RAM_GB=" .. mem_gb,
		"GPU=" .. gpu,
	}, "\n")
end

return M
