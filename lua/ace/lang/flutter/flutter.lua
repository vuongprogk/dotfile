if Ace.config.executable.flutter then
	return {
		"akinsho/flutter-tools.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		event = { "BufReadPost", "BufWritePost", "BufNewFile" },
		cond = vim.fs.find({ "pubspec.yaml" }, { upward = true })[1] and true or false,
		opts = {
			decorations = {
				statusline = {
					app_version = true,
					device = true,
					project_config = true,
				},
			},
			dev_log = {
				enabled = true,
				notify_errors = false, -- if there is an error whilst running then notify the user
				open_cmd = "tabnew", -- command to use to open the log buffer
			},
		},
	}
else
	return {
		"akinsho/flutter-tools.nvim",
		cond = false,
	}
end
