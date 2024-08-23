-- INSTRUCCIONES
-- ejecutas :Mason, presionas 5 para elegir 'formatters'
-- eliges el necesario y presionas i, para desinstalar usas x.

require("mason").setup({
	ui = {
    -- stylua: ignore
		icons = {
			package_installed   = "󰄴",
			package_pending     = "󰦖",
			package_uninstalled = "󱧕",
		},
	},
})
