local have_make = vim.fn.executable("make") == 1 and true or false
local have_cmake = vim.fn.executable("cmake") == 1 and true or false
local picker = {
	name = "telescope",
	commands = {
		files = "find_files",
	},
	-- this will return a function that calls telescope.
	-- cwd will default to lazyvim.util.get_root
	-- for `files`, git_files or find_files will be chosen depending on .git
	---@param builtin string
	---@param opts? Ace.util.pick.Opts
	open = function(builtin, opts)
		opts = opts or {}
		opts.follow = opts.follow ~= false
		if opts.cwd and opts.cwd ~= vim.uv.cwd() then
			local function open_cwd_dir()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				Ace.pick.open(
					builtin,
					vim.tbl_deep_extend("force", {}, opts or {}, {
						root = false,
						default_text = line,
					})
				)
			end
			---@diagnostic disable-next-line: inject-field
			opts.attach_mappings = function(_, map)
				-- opts.desc is overridden by telescope, until it's changed there is this fix
				map("i", "<a-c>", open_cwd_dir, { desc = "Open cwd Directory" })
				return true
			end
		end

		require("telescope.builtin")[builtin](opts)
	end,
}
if not Ace.pick.register(picker) then
	return {}
end
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
			{
				"<leader>,",
				"<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
				desc = "Switch Buffer",
			},
			{ "<leader>ff", Ace.pick("files"), desc = "Find Files (Root Dir)" },
			{ "<leader>fF", Ace.pick("files", { root = false }), desc = "Find Files (cwd)" },
			{ "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Find buffers is opening", remap = true },
			{ "<leader>sg", Ace.pick("live_grep"), desc = "Grep (Root Dir)" },
			{ "<leader>sG", Ace.pick("live_grep", { root = false }), desc = "Grep (cwd)" },
			{ "<leader>fh", "<cmd>Telescope help_tag<CR>", desc = "Find help tag", remap = true },
			{ "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "Find Files (git-files)" },
			{ "<leader>fc", Ace.pick.config_files(), desc = "Find Config File" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			{ "<leader>fR", Ace.pick("oldfiles", { cwd = vim.uv.cwd() }), desc = "Recent (cwd)" },
			{ "<leader>sq", "<cmd>Telescope quickfix<cr>", desc = "Quickfix List" },
			{ "<leader>nh", "<cmd>Telescope notify<CR>", desc = "Notification history", remap = true },
			{ "<leader>nt", "<cmd>Telescope noice<CR>", desc = "Noice history", remap = true },
			{ "<leader>sw", Ace.pick("grep_string", { word_match = "-w" }), desc = "Word (Root Dir)" },
			{ "<leader>sW", Ace.pick("grep_string", { root = false, word_match = "-w" }), desc = "Word (cwd)" },
			{ "<leader>sw", Ace.pick("grep_string"), mode = "v", desc = "Selection (Root Dir)" },
			{ "<leader>sW", Ace.pick("grep_string", { root = false }), mode = "v", desc = "Selection (cwd)" },
			{ "<leader>uC", Ace.pick("colorscheme", { enable_preview = true }), desc = "Colorscheme with Preview" },
		},
		opts = function()
			local actions = require("telescope.actions")

			local open_with_trouble = function(...)
				return require("trouble.sources.telescope").open(...)
			end
			local find_files_no_ignore = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				Ace.pick("find_files", { no_ignore = true, default_text = line })()
			end
			local find_files_with_hidden = function()
				local action_state = require("telescope.actions.state")
				local line = action_state.get_current_line()
				Ace.pick("find_files", { hidden = true, default_text = line })()
			end
			local function find_command()
				if 1 == vim.fn.executable("rg") then
					return { "rg", "--files", "--color", "never", "-g", "!.git" }
				elseif 1 == vim.fn.executable("fd") then
					return { "fd", "--type", "f", "--color", "never", "-E", ".git" }
				elseif 1 == vim.fn.executable("fdfind") then
					return { "fdfind", "--type", "f", "--color", "never", "-E", ".git" }
				elseif 1 == vim.fn.executable("find") and vim.fn.has("win32") == 0 then
					return { "find", ".", "-type", "f" }
				elseif 1 == vim.fn.executable("where") then
					return { "where", "/r", ".", "*" }
				end
			end
			return {
				defaults = {
					prompt_prefix = " ",
					selection_caret = " ",
					-- open files in the first window that is an actual file.
					-- use the current window if no other window is available.
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
					mappings = {
						i = {
							["<c-t>"] = open_with_trouble,
							["<a-t>"] = open_with_trouble,
							["<a-i>"] = find_files_no_ignore,
							["<a-h>"] = find_files_with_hidden,
							["<C-Down>"] = actions.cycle_history_next,
							["<C-Up>"] = actions.cycle_history_prev,
							["<C-f>"] = actions.preview_scrolling_down,
							["<C-b>"] = actions.preview_scrolling_up,
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
						},
						n = {
							["q"] = actions.close,
						},
					},
				},
				pickers = {
					find_files = {
						find_command = find_command,
						hidden = true,
					},
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
	{
		"neovim/nvim-lspconfig",
		opts = function()
			local Keys = require("ace.coding.lsp.keymaps").get()
      -- stylua: ignore
      vim.list_extend(Keys, {
        { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition", has = "definition" },
        { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References", nowait = true },
        { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
        { "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
      })
		end,
	},
}
