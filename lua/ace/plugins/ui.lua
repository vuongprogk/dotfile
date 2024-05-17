return {
	--bufferline
	{
		"akinsho/bufferline.nvim",
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
		opts = {
			options = {
				-- globalstatus = false,
				theme = "horizon",
			},
		},
	},

	--setup nui
	{

		"MunifTanjim/nui.nvim",
		opts = nil,
	},
	--setup noice
	{
		"folke/noice.nvim",
		opts = {
			lsp = {
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
				progress = {
					enabled = false,
				},
				message = {
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
				inc_rename = true,
			},
			views = {
				mini = {
					win_options = {
						winblend = 0,
					},
				},
			},
		},
	},
	-- setup notify
	{
		"rcarriga/nvim-notify",
		keys = {
			{
				"<leader>un",
				function()
					require("notify").dismiss({ silent = true, pending = true })
				end,
				desc = "Dismiss All Notifications",
			},
		},
		opts = {
			stages = "static",
			timeout = 3000,
			fps = 60,
		},
	},
}
