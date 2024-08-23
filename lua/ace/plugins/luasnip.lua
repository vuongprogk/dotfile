return {
	"L3MON4D3/LuaSnip",
	lazy = true,
	build = (require("ace.custom.os").getName() == "Windows")
			and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
		or nil,
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		{
			"nvim-cmp",
			dependencies = {
				"saadparwaiz1/cmp_luasnip",
			},
			opts = function(_, opts)
				local luasnip = require("luasnip")
				local cmp = require("cmp")
				opts.snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				}
				opts.mapping = vim.tbl_extend("force", opts.mapping, {
					["<Tab>"] = cmp.mapping(function(fallback) -- super tab
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				})
				local abort_servers = { "dartls" }
				local list_server = vim.lsp.get_clients()
				local function has_server(abort_list, server_check)
					for _, server in ipairs(abort_list) do
						if server.name == server_check then
							return true
						end
					end
					return false
				end
				for _, server in ipairs(list_server) do
					if not has_server(abort_servers, server) then
						table.insert(opts.sources, { name = "luasnip", priority = 750 })
					end
				end
			end,
		},
	},
	opts = {
		history = true,
		delete_check_events = "TextChanged",
	},
}
