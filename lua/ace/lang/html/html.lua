return {
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				html = {},
				cssls = {},
				emmet_language_server = {
					filetypes = {
						"html",
						"typescriptreact",
						"javascriptreact",
						"css",
						"sass",
						"scss",
						"less",
						"svelte",
					},
				},
			},
		},
	},
}
