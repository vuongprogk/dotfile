return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "go", "gomod", "gowork", "gosum" } },
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				gopls = {
					settings = {
						gopls = {
							gofumpt = true,
							codelenses = {
								gc_details = false,
								generate = true,
								regenerate_cgo = true,
								run_govulncheck = true,
								test = true,
								tidy = true,
								upgrade_dependency = true,
								vendor = true,
							},
							hints = {
								assignVariableTypes = true,
								compositeLiteralFields = true,
								compositeLiteralTypes = true,
								constantValues = true,
								functionTypeParameters = true,
								parameterNames = true,
								rangeVariableTypes = true,
							},
							analyses = {
								fieldalignment = true,
								nilness = true,
								unusedparams = true,
								unusedwrite = true,
								useany = true,
							},
							usePlaceholders = true,
							completeUnimported = true,
							staticcheck = true,
							directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
						},
					},
				},
			},
			setup = {
				gopls = function(_, opts)
					Ace.lsp.on_attach(function(client, _)
						if not client.server_capabilities.semanticTokensProvider then
							local semantic = client.config.capabilities.textDocument.semanticTokens
							client.server_capabilities.semanticTokensProvider = {
								full = true,
								legend = {
									tokenModifiers = semantic.tokenModifiers,
								},
								range = true,
							}
						end
					end, "gopls")
					-- end workaround
				end,
			},
		},
	},
	{
		"williamboman/mason.nvim",
		opts = { ensure_installed = { "goimports", "gofumpt", "gomodifytags", "impl", "delve" } },
	},
	{
		"mfussenegger/nvim-dap",
		optional = true,
		dependencies = {
			{
				"leoluz/nvim-dap-go",
				opts = {},
			},
		},
	},
}
