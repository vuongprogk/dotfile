return {
	{
		"L3MON4D3/LuaSnip",
		event = "InsertEnter",
		version = "*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		build = function()
			if require("ace.custom.os").getName() == "Windows" then
				vim.notify("Can't install jsregexp on window")
				return nil
			end
			return "make install_jsregexp"
		end,
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			{
				"rafamadriz/friendly-snippets",
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
				end,
			},
			{
				"saadparwaiz1/cmp_luasnip",
			},
		},
		config = function()
			local cmp = require("cmp")
			local config = cmp.get_config()
			local luasnip = require("luasnip")
			config.snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			}
			config.mapping = cmp.mapping.preset.insert({

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

			table.insert(config.sources, { name = "luasnip" })
			cmp.setup(config)
		end,
	},
}
