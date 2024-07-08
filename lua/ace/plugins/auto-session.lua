return {
	"rmagatti/auto-session",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	cmd = {
		"SessionRestore",
		"SessionSave",
		"SessionDelete",
		"Autosession",
	},
	keys = {
		{
			"<leader>wr",
			"<cmd>SessionRestore<CR>",
			{ desc = "Restore session for cwd", mode = { "n", "v" } },
		},
		{
			"<leader>ws",
			"<cmd>SessionSave<CR>",
			{ desc = "Save session for auto session root dir", mode = { "n", "v" } },
		},
		{
			"<leader>wd",
			"<cmd>SessionDelete<CR>",
			{ desc = "Delete session", mode = { "n", "v" } },
		},
		{
			"<Leader>ls",
			"<cmd>Telescope session-lens<CR>",
			{ desc = "Search session", mode = { "n", "v" } },
		},
	},
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
		post_restore_cmds = {
			function()
				local nvim_tree = require("nvim-tree")
				nvim_tree.change_dir(vim.fn.getcwd())
			end,
			"NvimTreeFindFileToggle",
		},
		pre_save_cmds = {
			function()
				local nvim_visible = require("nvim-tree.view")
				if nvim_visible.is_visible() then
					vim.cmd("NvimTreeClose")
				end
			end,
		},
	},
}
