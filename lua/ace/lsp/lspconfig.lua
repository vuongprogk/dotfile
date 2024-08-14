return {
	{
		"folke/lazydev.nvim",
		dependencies = "hrsh7th/nvim-cmp",
		cond = vim.fs.find({ "init.lua" }, { upward = true })[1] and true or false,
		ft = "lua", -- only load on lua files
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{
				"antosha417/nvim-lsp-file-operations",
				config = true,
			},
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			-- import lspconfig plugin
			local lspconfig = require("lspconfig")

			require("ace.custom.auto-cmd")

			local mason_lspconfig = require("mason-lspconfig")
			-- import cmp-nvim-lsp plugin
			local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

			local capabilities = vim.tbl_deep_extend(
				"force",
				{},
				vim.lsp.protocol.make_client_capabilities(),
				has_cmp and cmp_nvim_lsp.default_capabilities() or {},
				{
					workspace = {
						fileOperations = {
							didRename = true,
							willRename = true,
						},
					},
				}
			)
			-- capabilities.textDocument.completion.completionItem.snippetSupport = false
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			mason_lspconfig.setup_handlers({
				-- default handler for installed servers
				function(server_name)
					lspconfig[server_name].setup({
						capabilities = capabilities,
					})
				end,
				["svelte"] = function()
					-- configure svelte server
					lspconfig["svelte"].setup({
						capabilities = capabilities,
						on_attach = function(client, _)
							vim.api.nvim_create_autocmd("BufWritePost", {
								pattern = { "*.js", "*.ts" },
								callback = function(ctx)
									-- Here use ctx.match instead of ctx.file
									client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
								end,
							})
						end,
					})
				end,
				["jdtls"] = function()
					local is_maven_project = vim.fs.find({ "gradlew", "mvnw", "pom.xml" }, { upward = true })[1]
					-- NOTE: if cwd is maven project then not start local jdtls instead using nvim jdtls
					if not is_maven_project then
						lspconfig["jdtls"].setup({
							capabilities = capabilities,
						})
					end
					-- TODO: do nothing
				end,
				["graphql"] = function()
					-- configure graphql language server
					lspconfig["graphql"].setup({
						capabilities = capabilities,
						filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
					})
				end,
				["emmet_ls"] = function()
					-- configure emmet language server
					lspconfig["emmet_ls"].setup({
						capabilities = capabilities,
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
					})
				end,
				["lua_ls"] = function()
					-- configure lua server (with special settings)
					lspconfig["lua_ls"].setup({
						capabilities = capabilities,
						settings = {
							Lua = {
								-- make the language server recognize "vim" global
								diagnostics = {
									globals = { "vim" },
								},
								completion = {
									callSnippet = "Replace",
								},
							},
						},
					})
				end,
				["tsserver"] = function()
					lspconfig["tsserver"].setup({
						capabilities = capabilities,
					})
				end,
				["csharp_ls"] = function()
					lspconfig["csharp_ls"].setup({
						capabilities = capabilities,
					})
				end,
			})
		end,
	},

	{
		"hrsh7th/cmp-nvim-lsp",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"neovim/nvim-lspconfig",
			{
				"hrsh7th/nvim-cmp",
				opts = function(_, opts)
					table.insert(opts.sources, {
						name = "nvim_lsp",
						priority = 1000,
						entry_filter = function(entry)
							local list_server = vim.lsp.get_clients()
							for _, server in ipairs(list_server) do
								if server.name == "tsserver" then
									return require("cmp").lsp.CompletionItemKind.Snippet ~= entry:get_kind()
								end
							end
							return true
						end,
					})
				end,
			},
		},
	},
}
