local M = {}

-- Valor técnico neutro
local UNKNOWN = "unknown"

-- Ejecuta fastfetch y devuelve JSON decodificado o nil
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

-- Busca un bloque por type
local function find_block(data, block_type)
	for _, item in ipairs(data) do
		if item.type == block_type and item.result then
			return item.result
		end
	end
	return nil
end

-- Formateo final del bloque
function M.get_system_info_block()
	local data = run_fastfetch()

	if not data then
		return [[
System context:
- OS: unknown
- Distro: unknown
- Kernel: unknown
- Architecture: unknown

Environment context:
- Shell: unknown
- Terminal: unknown
- Window manager: unknown
- Neovim: unknown

Hardware context:
- CPU cores: unknown
- Memory: unknown
- GPU: unknown
]]
	end

	local os = find_block(data, "OS") or {}
	local kernel = find_block(data, "Kernel") or {}
	local shell = find_block(data, "Shell") or {}
	local wm = find_block(data, "WM") or {}
	local cpu = find_block(data, "CPU") or {}
	local memory = find_block(data, "Memory") or {}
	local gpus = find_block(data, "GPU") or {}

	local distro = os.id or UNKNOWN
	local arch = kernel.architecture or UNKNOWN
	local kernel_name = kernel.release or UNKNOWN

	local shell_name = shell.exeName or UNKNOWN
	local wm_name = wm.prettyName or UNKNOWN

	local cores = cpu.cores and cpu.cores.logical or UNKNOWN

	local mem_gb = UNKNOWN
	if memory.total then
		mem_gb = math.floor(memory.total / 1024 / 1024 / 1024 + 0.5) .. " GB"
	end

	local gpu_name = UNKNOWN
	if type(gpus) == "table" and gpus[1] and gpus[1].name then
		gpu_name = gpus[1].name
	end

	local nvim_version = vim.version()
	local nvim_str = string.format("%d.%d.%d", nvim_version.major, nvim_version.minor, nvim_version.patch)

	return string.format(
		[[
System context:
- OS: Linux
- Distro: Arch-family (%s)
- Kernel: %s
- Architecture: %s

Environment context:
- Shell: %s
- Terminal: kitty
- Window manager: %s
- Neovim: %s

Hardware context:
- CPU cores: %s
- Memory: %s
- GPU: %s
]],
		distro,
		kernel_name,
		arch,
		shell_name,
		wm_name,
		nvim_str,
		cores,
		mem_gb,
		gpu_name
	)
end

return M
