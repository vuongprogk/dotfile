return {
	"rmagatti/auto-session",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	event = "VeryLazy",
	opts = {
		auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
		auto_save_enabled = true,
		auto_session_use_git_branch = true,
		close_unsupported_windows = true,
		session_lens = {
			load_on_setup = true,
			theme_conf = { border = true },
			previewer = false,
			buftypes_to_ignore = {},
		},
		silent_restore = false,
		post_restore_cmds = {
			function()
				require("nvim-tree").change_dir(vim.fn.getcwd())
			end,
		},
		pre_save_cmds = {
			function()
				if require("lazy.core.config").plugins["nvim-tree.lua"]._.loaded ~= nil then
					if require("nvim-tree.view").is_visible() == true then
						vim.cmd("NvimTreeClose")
					end
				end
			end,
		},
	},
	keys = {
		{
			"<leader>wr",
			"<cmd>SessionRestore<CR>",
			{ desc = "Restore session for cwd" },
		},
		{
			"<leader>ws",
			"<cmd>SessionSave<CR>",
			{ desc = "Save session for auto session root dir" },
		},
		{
			"<leader>wd",
			"<cmd>SessionDelete<CR>",
			{ desc = "Delete session" },
		},
		{
			"<Leader>ls",
			"<cmd>Telescope session-lens<CR>",
			{ desc = "Search session" },
		},
	},
}
