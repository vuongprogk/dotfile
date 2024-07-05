return {
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		branch = "regexp", -- Use this branch for the new version
		cmd = "VenvSelect",
		enabled = function()
			local present, telescope = pcall(require, "telescope")
			if not present then
				return false
			else
				return true
			end
		end,
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
