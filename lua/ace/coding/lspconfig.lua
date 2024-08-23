local function on_attach(on_attach, name)
	return vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf ---@type number
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			if client and (not name or client.name == name) then
				return on_attach(client, buffer)
			end
		end,
	})
end
local _supports_method = {}

local function _check_methods(client, buffer)
	-- don't trigger on invalid buffers
	if not vim.api.nvim_buf_is_valid(buffer) then
		return
	end
	-- don't trigger on non-listed buffers
	if not vim.bo[buffer].buflisted then
		return
	end
	-- don't trigger on nofile buffers
	if vim.bo[buffer].buftype == "nofile" then
		return
	end
	for method, clients in pairs(_supports_method) do
		clients[client] = clients[client] or {}
		if not clients[client][buffer] then
			if client.supports_method and client.supports_method(method, { bufnr = buffer }) then
				clients[client][buffer] = true
				vim.api.nvim_exec_autocmds("User", {
					pattern = "LspSupportsMethod",
					data = { client_id = client.id, buffer = buffer, method = method },
				})
			end
		end
	end
end
local function on_dynamic_capability(fn, opts)
	return vim.api.nvim_create_autocmd("User", {
		pattern = "LspDynamicCapability",
		group = opts and opts.group or nil,
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local buffer = args.data.buffer ---@type number
			if client then
				return fn(client, buffer)
			end
		end,
	})
end
local function on_supports_method(method, fn)
	_supports_method[method] = _supports_method[method] or setmetatable({}, { __mode = "k" })
	return vim.api.nvim_create_autocmd("User", {
		pattern = "LspSupportsMethod",
		callback = function(args)
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			local buffer = args.data.buffer ---@type number
			if client and method == args.data.method then
				return fn(client, buffer)
			end
		end,
	})
end
local function setup()
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
	on_attach(_check_methods)
	on_dynamic_capability(_check_methods)
end
return {
	{
		"folke/lazydev.nvim",
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
			"williamboman/mason.nvim",
			{
				"williamboman/mason-lspconfig.nvim",
				config = function() end,
			},
		},
		opts = function()
			local icons = {
				Error = " ",
				Warn = " ",
				Hint = " ",
				Info = " ",
			}
			local ret = {
				icons = icons,
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
				inlay_hints = {
					enabled = true,
					exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
				},
				codelens = {
					enabled = false,
				},
				-- Enable lsp cursor word highlighting
				document_highlight = {
					enabled = true,
				},
				capabilities = {
					workspace = {
						fileOperations = {
							didRename = true,
							willRename = true,
						},
					},
				},
				servers = {
					lua_ls = {
						settings = {
							Lua = {
								workspace = {
									checkThirdParty = false,
								},
								codeLens = {
									enable = true,
								},
								completion = {
									callSnippet = "Replace",
								},
								doc = {
									privateName = { "^_" },
								},
								hint = {
									enable = true,
									setType = false,
									paramType = true,
									paramName = "Disable",
									semicolon = "Disable",
									arrayIndex = "Disable",
								},
							},
						},
					},
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
			}
			return ret
		end,
		config = function(_, opts)
			require("ace.core.lspmapping")
			setup()

			-- diagnostics signs
			if vim.fn.has("nvim-0.10.0") == 0 then
				if type(opts.diagnostics.signs) ~= "boolean" then
					for severity, icon in pairs(opts.diagnostics.signs.text) do
						local name = vim.diagnostic.severity[severity]:lower():gsub("^%l", string.upper)
						name = "DiagnosticSign" .. name
						vim.fn.sign_define(name, { text = icon, texthl = name, numhl = "" })
					end
				end
			end

			if vim.fn.has("nvim-0.10") == 1 then
				-- inlay hints
				if opts.inlay_hints.enabled then
					on_supports_method("textDocument/inlayHint", function(client, buffer)
						if
							vim.api.nvim_buf_is_valid(buffer)
							and vim.bo[buffer].buftype == ""
							and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
						then
							vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
						end
					end)
				end

				-- code lens
				if opts.codelens.enabled and vim.lsp.codelens then
					on_supports_method("textDocument/codeLens", function(client, buffer)
						vim.lsp.codelens.refresh()
						vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
							buffer = buffer,
							callback = vim.lsp.codelens.refresh,
						})
					end)
				end
			end
			if type(opts.diagnostics.virtual_text) == "table" and opts.diagnostics.virtual_text.prefix == "icons" then
				opts.diagnostics.virtual_text.prefix = vim.fn.has("nvim-0.10.0") == 0 and "●"
					or function(diagnostic)
						local icons = opts.icons
						for d, icon in pairs(icons) do
							if diagnostic.severity == vim.diagnostic.severity[d:upper()] then
								return icon
							end
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
				opts.capabilities or {}
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
	{ "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
}
