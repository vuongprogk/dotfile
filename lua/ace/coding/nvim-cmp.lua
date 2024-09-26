return {
	{
		"hrsh7th/nvim-cmp",
		version = false, -- last release is way too old
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
		},
		opts = function()
			vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
			local cmp = require("cmp")
			local auto_select = true
			local defaults = require("cmp.config.default")()
			return {
				auto_brackets = {}, -- configure any filetype to auto add brackets
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
					["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
					["<C-s>"] = cmp.mapping.complete(), -- show completion suggestions because some terminal emulator not word
					["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
					["<C-e>"] = cmp.mapping.abort(), -- close completion window
					["<C-CR>"] = cmp.mapping.abort(), -- close completion window
					["<S-CR>"] = Ace.cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<CR>"] = Ace.cmp.confirm({ select = auto_select }),
				}),
				preselect = auto_select and cmp.PreselectMode.Item or cmp.PreselectMode.None,
				completion = {
					completeopt = "menu,menuone,noinsert" .. (auto_select and "" or ",noselect"),
				},
				experimental = {
					ghost_text = {
						hl_group = "CmpGhostText",
					},
				},
				sorting = defaults.sorting,
				formatting = {
					format = function(_, item)
						local icons = Ace.config.icons.kinds
						if icons[item.kind] then
							item.kind = icons[item.kind] .. item.kind
						end

						local widths = {
							abbr = vim.g.cmp_widths and vim.g.cmp_widths.abbr or 40,
							menu = vim.g.cmp_widths and vim.g.cmp_widths.menu or 30,
						}

						for key, width in pairs(widths) do
							if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
								item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
							end
						end

						return item
					end,
				},
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "path" },
				}, {
					{
						name = "buffer",
						option = {
							get_bufnrs = function()
								return { vim.api.nvim_get_current_buf() }
							end,
						},
					},
				}),
			}
		end,
		main = "ace.core.util.cmp",
	},
	{
		"L3MON4D3/LuaSnip",
		lazy = true,
		build = (not Ace.is_win())
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
					opts.snippet = {
						expand = function(args)
							require("luasnip").lsp_expand(args.body)
						end,
					}
					table.insert(opts.sources, { name = "luasnip", max_item_count = 5 })
				end,
			},
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},
	-- config super-tab
	{
		"hrsh7th/nvim-cmp",
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
					and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			local cmp = require("cmp")
			local luasnip = require("luasnip")

			opts.mapping = vim.tbl_extend("force", opts.mapping, {
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					elseif has_words_before() then
						cmp.complete()
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			})
		end,
	},
}
