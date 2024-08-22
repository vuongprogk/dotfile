return {
	"L3MON4D3/LuaSnip",
	lazy = true,
	build = (require("ace.custom.os").getName() == "Windows")
			and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
		or nil,
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
				local cmp = require("cmp")
				local luasnip = require("luasnip")
				opts.snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				}
				table.insert(opts.sources, { name = "luasnip" })
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
			end,
		},
	},
	opts = {
		history = true,
		delete_check_events = "TextChanged",
	},
}
