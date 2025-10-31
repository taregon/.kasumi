-- ███╗   ███╗ █████╗ ███████╗ ██████╗ ███╗   ██╗
-- ████╗ ████║██╔══██╗██╔════╝██╔═══██╗████╗  ██║
-- ██╔████╔██║███████║███████╗██║   ██║██╔██╗ ██║
-- ██║╚██╔╝██║██╔══██║╚════██║██║   ██║██║╚██╗██║
-- ██║ ╚═╝ ██║██║  ██║███████║╚██████╔╝██║ ╚████║
-- ╚═╝     ╚═╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚═╝  ╚═══╝
-- INSTRUCCIONES
-- ejecutas :Mason, presionas 5 para elegir 'formatters'
-- eliges el necesario y presionas i. Para desinstalar usas x.

require("mason").setup({
	ui = {
    -- stylua: ignore
		icons = {
			package_installed   = "󰄴",
			package_pending     = "󰦖",
			package_uninstalled = "󱧕",
		},
		border = "single",
	},
})
