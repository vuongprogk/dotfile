local have_make = vim.fn.executable("make") == 1 and true or false
local have_cmake = vim.fn.executable("cmake") == 1 and true or false
return {
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		dependencies = {
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = have_make and "make"
					or "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				enabled = have_make or have_cmake,
				config = function(plugin)
					Ace.on_load("telescope.nvim", function()
						local ok, err = pcall(require("telescope").load_extension, "fzf")
						if not ok then
							local lib = plugin.dir .. "/build/libfzf." .. (Ace.is_win() and "dll" or "so")
							if not vim.uv.fs_stat(lib) then
								Ace.warn("`telescope-fzf-native.nvim` not built. Rebuilding...")
								require("lazy").build({ plugins = { plugin }, show = false }):wait(function()
									vim.notify(
										"Rebuilding `telescope-fzf-native.nvim` done.\nPlease restart Neovim.",
										vim.log.levels.INFO
									)
								end)
							else
								vim.notify("Failed to load `telescope-fzf-native.nvim`:\n" .. err, vim.log.levels.ERROR)
							end
						end
					end)
				end,
			},
		},
		version = false,
		keys = {
			{ "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find file", remap = true },
			{ "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Find word in file", remap = true },
			{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers is opening", remap = true },
			{ "<leader>fh", "<cmd>Telescope help_tag<CR>", desc = "Find help tag", remap = true },
			{ "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "Find todo comment", remap = true },
			{ "<leader>nh", "<cmd>Telescope notify<CR>", desc = "Notification history", remap = true },
			{ "<leader>nt", "<cmd>Telescope noice<CR>", desc = "Noice history", remap = true },
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
			}
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
