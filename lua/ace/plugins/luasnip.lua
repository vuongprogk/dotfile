return {

	"L3MON4D3/LuaSnip",
	version = "*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	lazy = true,
	build = function()
		if require("ace.custom.os").getName() == "Windows" then
			vim.notify("Can't install jsregexp on window")
			return nil
		end
		return "make install_jsregexp"
	end,
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
				if not opts.mapping then
					opts.mapping = {}
				end
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

				if not opts.sources then
					opts.sources = {}
				end
				table.insert(opts.sources, { name = "luasnip", priority = 750 })
			end,
		},
	},
	opts = {
		history = true,
		delete_check_events = "TextChanged",
	},
}
