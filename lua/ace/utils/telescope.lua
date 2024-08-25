return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
			},
		},
		version = false,
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Telescope find file", remap = true } },
			{ "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Telescope find word in file", remap = true } },
			{
				"<leader>fb",
				"<cmd>Telescope buffers<CR>",
				{ desc = "Telescope find buffers is opening", remap = true },
			},
			{ "<leader>fh", "<cmd>Telescope help_tag<CR>", { desc = "Telescope find help tag", remap = true } },
			{ "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find todo comment", remap = true } },
			{ "<leader>nh", "<cmd>Telescope notify<CR>", { desc = "Notification history", remap = true } },
			{ "<leader>nt", "<cmd>Telescope noice<CR>", { desc = "Noice history", remap = true } },
		},
		opts = function()
			local actions = require("telescope.actions")
			return {
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
					},
					n = {
						["q"] = actions.close,
					},
				},
				defaults = {
					get_selection_window = function()
						local wins = vim.api.nvim_list_wins()
						table.insert(wins, 1, vim.api.nvim_get_current_win())
						for _, win in ipairs(wins) do
							local buf = vim.api.nvim_win_get_buf(win)
							if vim.bo[buf].buftype == "" then
								return win
							end
						end
						return 0
					end,
				},
				pickers = {
					find_files = {
						find_command = function()
							if 1 == vim.fn.executable("fd") then
								return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
							elseif 1 == vim.fn.executable("rg") then
								return { "rg", "--files", "--color", "never", "-g", "!.git" }
							elseif 1 == vim.fn.executable("fdfind") then
								return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
							elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
								return { "find", ".", "-type", "f" }
							elseif 1 == vim.fn.executable("where") then
								return { "where", "/r", ".", "*" }
							end
						end,
						hidden = true,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
				},
			}
		end,
		config = function()
			local ok_fzf, err_fzf = pcall(require("telescope").load_extension, "fzf")
			if not ok_fzf then
				vim.notify("Failed to load `telescope-fzf-native.nvim`:\n" .. err_fzf, vim.log.levels.ERROR, {})
			end
		end,
	},
	{
		"stevearc/dressing.nvim",
		lazy = true,
		init = function()
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.select = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.select(...)
			end
			---@diagnostic disable-next-line: duplicate-set-field
			vim.ui.input = function(...)
				require("lazy").load({ plugins = { "dressing.nvim" } })
				return vim.ui.input(...)
			end
		end,
	},
}
