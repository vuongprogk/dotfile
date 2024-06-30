return {
	"rmagatti/auto-session",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{
			"<leader>wr",
			function()
				require("auto-session").RestoreSession()
			end,
			{ desc = "Restore session for cwd", mode = { "n", "v" } },
		},
		{
			"<leader>ws",
			function()
				require("auto-session").SaveSession()
			end,
			{ desc = "Save session for auto session root dir", mode = { "n", "v" } },
		},
		{
			"<leader>wd",
			function()
				require("auto-session").DeleteSession()
			end,
			{ desc = "Delete session", mode = { "n", "v" } },
		},
		{
			"<Leader>ls",
			function()
				require("auto-session.session-lens").search_session()
			end,
			{ desc = "Search session", mode = { "n", "v" } },
		},
	},
	opts = {
		auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
		auto_save_enabled = true,
		auto_session_use_git_branch = true,
		close_unsupported_windows = true,
	},
}
