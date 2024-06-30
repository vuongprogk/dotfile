return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	keys = {
		{
			"<leader>ee",
			function()
				require("nvim-tree.api").tree.toggle()
			end,
			{ desc = "Toggle file explorer", mode = { "n", "v" } },
		},
		{
			"<leader>ef",
			function()
				require("nvim-tree.api").tree.toggle({ find_file = true, focus = true })
			end,
			{ desc = "Toggle file explorer on current file", mode = { "n", "v" } },
		},
		{
			"<leader>er",
			function()
				require("nvim-tree.api").tree.reload()
			end,
			desc = "Refresh file explorer",
		},
	},
	opts = {
		sync_root_with_cwd = true,
		view = {
			width = 40,
		},
		-- change folder arrow icons
		renderer = {
			indent_markers = {
				enable = true,
			},
			icons = {
				web_devicons = {
					file = {
						enable = true,
						color = true,
					},
					folder = {
						enable = false,
						color = true,
					},
				},
				git_placement = "after",
				show = {
					git = true,
				},
			},
		},
		actions = {
			open_file = {
				window_picker = {
					enable = false,
				},
			},
		},
		filters = {
			custom = { ".DS_Store" },
		},
		git = {
			ignore = false,
		},
	},
}
