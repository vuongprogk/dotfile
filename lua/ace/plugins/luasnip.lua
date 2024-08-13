return {

	"L3MON4D3/LuaSnip",
	version = "*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	event = "InsertEnter",
	build = function()
		if require("ace.custom.os").getName() == "Windows" then
			vim.notify("Can't install jsregexp on window", vim.log.levels.ERROR)
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
			"saadparwaiz1/cmp_luasnip",
			dependencies = {
				"nvim-cmp",
				opts = function(_, opts)
					local cmp = require("cmp")
					opts.snippet = {
						expand = function(args)
							require("luasnip").lsp_expand(args.body)
						end,
					}
					if not opts.mapping then
						opts.mapping = {}
					end
					opts.mapping = cmp.mapping.preset.insert({
						["<Tab>"] = cmp.mapping(function(fallback) -- super tab
							local luasnip = require("luasnip")

							if cmp.visible() then
								cmp.select_next_item()
							elseif luasnip.expand_or_jumpable() then
								luasnip.expand_or_jump()
							else
								fallback()
							end
						end, { "i", "s" }),
						["<S-Tab>"] = cmp.mapping(function(fallback)
							local luasnip = require("luasnip")

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
					table.insert(opts.sources, { name = "luasnip", priority = 1000 })
				end,
			},
		},
	},
	opts = {
		history = true,
		delete_check_events = "TextChanged",
	},
}
