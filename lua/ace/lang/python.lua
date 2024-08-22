return {
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		branch = "regexp", -- Use this branch for the new version
		cond = vim.fs.find({ ".venv", "venv" }, { upward = true, type = "directory" })[1] and true or false,
		event = "VeryLazy", -- Optional: needed only if you want to type `:VenvSelect` without a keymapping
		keys = {
			-- Keymap to open VenvSelector to pick a venv.
			{ "<leader>vs", "<cmd>VenvSelect<cr>" },
			-- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
			{ "<leader>vc", "<cmd>VenvSelectCached<cr>" },
		},
		opts = {
			settings = {
				options = {
					notify_user_on_venv_activation = true,
				},
			},
		},
		ft = "python",
	},
}
