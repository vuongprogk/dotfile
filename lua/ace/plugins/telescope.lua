return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-ui-select.nvim",
	},
	branch = "0.1.x",
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		telescope.setup({
			defaults = {
				path_display = { "smart" },
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
		telescope.load_extension("noice")
		telescope.load_extension("ui-select")
		telescope.load_extension("notify")
		local keymap = vim.keymap
		keymap.set({ "n", "v" }, "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Telescope search file" })
		keymap.set(
			{ "n", "v" },
			"<leader>fs",
			"<cmd>Telescope live_grep<cr>",
			{ desc = "Telescope search word in file" }
		)
		keymap.set({ "n", "v" }, "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Telescope read buffers" })
		keymap.set({ "n", "v" }, "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Telescope help tags" })
		keymap.set({ "n", "v" }, "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find todo comment" })
		keymap.set({ "n", "v" }, "<leader>nh", "<cmd>Telescope notify<CR>", {
			desc = "Notification history",
		})
	end,
}
