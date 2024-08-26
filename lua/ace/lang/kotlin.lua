return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				kotlin_language_server = {},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "kotlin" } },
	},
}
