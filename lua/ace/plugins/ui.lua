return {
	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{ "MunifTanjim/nui.nvim", opts = nil, lazy = true },
	--bufferline
	{
		"akinsho/bufferline.nvim",
		event = "VeryLazy",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				mode = "tabs",
				show_close_icon = false,
			},
		},
	},
	-- statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		dependencies = "nvim-tree/nvim-web-devicons",
		opts = {
			options = {
				theme = function()
					local colors = {
						blue = "#268bd2",
						black = "#080808",
						white = "#c6c6c6",
						red = "#ff5189",
						violet = "#d183e8",
						grey = "#303030",
						base03 = "#002b36",
						green = "#859900",
						magenta = "#d33682",
					}
					return {
						normal = {
							a = { fg = colors.black, bg = colors.blue, gui = "bold" },
							b = { fg = colors.white, bg = colors.grey },
							c = { fg = colors.white },
						},

						insert = { a = { fg = colors.black, bg = colors.green, gui = "bold" } },
						visual = { a = { fg = colors.black, bg = colors.violet, gui = "bold" } },
						replace = { a = { fg = colors.black, bg = colors.red, gui = "bold" } },

						inactive = {
							a = { fg = colors.white, bg = colors.black, gui = "bold" },
							b = { fg = colors.white, bg = colors.black },
							c = { fg = colors.white },
						},
					}
				end,
			},
			extensions = { "nvim-tree" },
		},
	},
	-- setup noice
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		opts = {
			messages = {
				view = "mini",
			},
			notify = {
				enabled = true,
				view = "notify",
			},
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				progress = {
					enabled = true,
				},
				message = {
					enabled = true,
					view = "mini",
					opts = {},
				},
				signature = {
					enabled = false,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						any = {
							{ find = "%d+L, %d+B" },
							{ find = "; after #%d+" },
							{ find = "; before #%d+" },
						},
					},
					view = "mini",
				},
			},
			presets = {
				bottom_search = true,
				command_palette = true,
				long_message_to_split = true,
				inc_rename = false,
				lsp_doc_border = true,
			},
			views = {
				mini = {
					win_options = {
						winblend = 0,
					},
				},
			},
			cmdline = {
				enabled = true,
				format = {
					cmdline = { title = "ACE" },
				},
			},
		},
	},
	-- setup notify
	{
		"rcarriga/nvim-notify",
		opts = {
			stages = "fade_in_slide_out",
			timeout = 5000,
			fps = 60,
		},
		config = function()
			vim.keymap.set("n", "<leader>un", function()
				require("notify").dismiss({ silent = true, pending = true })
			end, { desc = "Dismiss All Notifications" })
		end,
	},
}
