local icons = {
	Error = " ",
	Warn = " ",
	Hint = " ",
	Info = " ",
}
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
				"williamboman/mason-lspconfig.nvim",
				opts = {},
			},
		},
		opts = {
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = icons.Error,
						[vim.diagnostic.severity.WARN] = icons.Warn,
						[vim.diagnostic.severity.HINT] = icons.Hint,
						[vim.diagnostic.severity.INFO] = icons.Info,
					},
				},
			},
			servers = {
				lua_ls = {},
				emmet_ls = {
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
				graphql = {
					filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
				},
				jdtls = {
					handlers = {
						["$/progress"] = function() end,
					},
				},
				clangd = {},
				tsserver = {},
				pyright = {},
				html = {},
				cssls = {},
				tailwindcss = {},
				omnisharp = {
					handlers = {
						["textDocument/definition"] = function(...)
							return require("omnisharp_extended").handler(...)
						end,
					},
					keys = {
						{
							"gd",
							function()
								require("omnisharp_extended").telescope_lsp_definitions()
							end,
							desc = "Goto Definition",
						},
					},
					enable_roslyn_analyzers = true,
					organize_imports_on_format = true,
					enable_import_completion = true,
				},
			},
			setup = {
				jdtls = function()
					local is_maven_project = vim.fs.find({ "gradlew", "mvnw", "pom.xml" }, { upward = true })[1]
					-- NOTE: if cwd is maven project then not start local jdtls instead using nvim jdtls
					if is_maven_project then
						return true
					end
					return false
				end,
			},
		},
		config = function(_, opts)
			-- setup
			local register_capability = vim.lsp.handlers["client/registerCapability"]
			vim.lsp.handlers["client/registerCapability"] = function(err, res, ctx)
				---@diagnostic disable-next-line: no-unknown
				local ret = register_capability(err, res, ctx)
				local client = vim.lsp.get_client_by_id(ctx.client_id)
				if client then
					for buffer in pairs(client.attached_buffers) do
						vim.api.nvim_exec_autocmds("User", {
							pattern = "LspDynamicCapability",
							data = { client_id = client.id, buffer = buffer },
						})
					end
				end
				return ret
			end

			if vim.fn.has("nvim-0.10.0") == 0 then
				if type(opts.diagnostics.signs) ~= "boolean" then
					for severity, icon in pairs(opts.diagnostics.signs.text) do
						local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
						name = "DiagnosticSign" .. name
						vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
					end
				end
			end

			vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

			local servers = opts.servers
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
			local function setup(server)
				local server_opts = vim.tbl_deep_extend("force", {
					capabilities = vim.deepcopy(capabilities),
				}, servers[server] or {})
				if server_opts.enabled == false then
					return
				end

				if opts.setup[server] then
					if opts.setup[server](server, server_opts) then
						return
					end
				end
				require("lspconfig")[server].setup(server_opts)
			end
			local have_mason, mlsp = pcall(require, "mason-lspconfig")
			local all_mslp_servers = {}
			if have_mason then
				all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
			end

			local ensure_installed = {} ---@type string[]
			for server, server_opts in pairs(servers) do
				if server_opts then
					server_opts = server_opts == true and {} or server_opts
					if server_opts.enabled ~= false then
						-- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
						if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
							setup(server)
						else
							ensure_installed[#ensure_installed + 1] = server
						end
					end
				end
			end
			if have_mason then
				mlsp.setup({
					ensure_installed = ensure_installed,
					handlers = { setup },
				})
			end
		end,
	},
	{
		"hrsh7th/cmp-nvim-lsp",
		event = "InsertEnter",
		dependencies = {
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
	{ "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
}
