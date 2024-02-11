return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({
        PATH = "prepend"
      })
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"clangd",
					"tsserver",
					"clangd",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"williamboman/nvim-lsp-installer",
		config = function()
			require("nvim-lsp-installer").setup({
				automatic_installation = true,
				ui = {
					icons = {
						server_installed = "✓",
						server_pending = "➜",
						server_uninstalled = "✗",
					},
				},
			})
		end,
	},
}
