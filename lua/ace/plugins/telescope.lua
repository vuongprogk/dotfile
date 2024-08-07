return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
		version = false,
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			telescope.setup({
				defaults = {
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous, -- move to prev result
							["<C-j>"] = actions.move_selection_next, -- move to next result
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
			telescope.load_extension("notify")
			telescope.load_extension("noice")

			local keymap = vim.keymap
			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
			keymap.set({ "n", "v" }, "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find todo comment" })
			keymap.set({ "n", "v" }, "<leader>nh", "<cmd>Telescope notify<CR>", {
				desc = "Notification history",
			})
			keymap.set({ "n", "v" }, "<leader>nt", "<cmd>Telescope noice<CR>", {
				desc = "Noice history",
			})
		end,
	},
}
