return {
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		version = false,
		opts = function(_, opts)
			opts.defaults = {
				mappings = {
					i = {
						["<C-k>"] = require("telescope.actions").move_selection_previous, -- move to prev result
						["<C-j>"] = require("telescope.actions").move_selection_next, -- move to next result
					},
				},
			}
			local keymap = vim.keymap
			vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", {})
			vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", {})
			vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", {})
			vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", {})
			keymap.set({ "n", "v" }, "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find todo comment" })
			keymap.set({ "n", "v" }, "<leader>nh", "<cmd>Telescope notify<CR>", {
				desc = "Notification history",
			})
			keymap.set({ "n", "v" }, "<leader>nt", "<cmd>Telescope noice<CR>", {
				desc = "Noice history",
			})
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope.nvim",
				opts = function(_, opts)
					if not opts.extensions then
						opts.extensions = {}
					end
					opts.extensions.fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					}
				end,
			},
		},
		event = "VeryLazy",
		build = "make",
		config = function()
			if vim.tbl_get(require("lazy.core.config"), "plugins", "telescope.nvim", "_", "loaded") ~= nil then
				local ok, err = pcall(require("telescope").load_extension, "fzf")
				if not ok then
					vim.notify("Failed to load `telescope-fzf-native.nvim`:\n" .. err, "error", {})
				end
			end
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		dependencies = {
			{
				"nvim-telescope/telescope.nvim",
				opts = function(_, opts)
					opts.extensions["ui-select"] = {
						theme = "dropdown",
						results_title = false,

						sorting_strategy = "ascending",
						layout_strategy = "center",
						layout_config = {
							preview_cutoff = 1, -- Preview should always show (unless previewer = false)

							width = function(_, max_columns, _)
								return math.min(max_columns, 80)
							end,

							height = function(_, _, max_lines)
								return math.min(max_lines, 15)
							end,
						},

						border = true,
						borderchars = {
							prompt = { "─", "│", " ", "│", "╭", "╮", "│", "│" },
							results = { "─", "│", "─", "│", "├", "┤", "╯", "╰" },
							preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
						},
					}
				end,
			},
		},
		event = "VeryLazy",
		config = function()
			if vim.tbl_get(require("lazy.core.config"), "plugins", "telescope.nvim", "_", "loaded") ~= nil then
				local ok, err = pcall(require("telescope").load_extension, "ui-select")
				if not ok then
					vim.notify("Failed to load `telescope-ui-select.nvim`:\n" .. err, "error", {})
				end
			end
		end,
	},
}
