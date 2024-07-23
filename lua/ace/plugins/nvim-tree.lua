return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = { "VeryLazy" },
	opts = {
		sync_root_with_cwd = true,
		view = {
			width = 35,
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
				modified_placement = "after",
				show = {
					git = true,
				},
			},
		},
		actions = {
			open_file = {
				quit_on_open = true,
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
		modified = {
			enable = true,
			show_on_dirs = true,
			show_on_open_dirs = true,
		},
	},
	config = function(_, config)
		require("nvim-tree").setup(config)
		local keymap = vim.keymap
		keymap.set({ "n", "v" }, "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" })
		keymap.set({ "n", "v" }, "<leader>ef", function()
			local tree_is_visible = require("nvim-tree.view")
			if tree_is_visible.is_visible() then
				vim.cmd("NvimTreeFocus")
			else
				vim.cmd("NvimTreeFindFileToggle")
			end
		end, { desc = "Toggle file explorer on current file" })
		keymap.set({ "n", "v" }, "<leader>ee", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
	end,
}
