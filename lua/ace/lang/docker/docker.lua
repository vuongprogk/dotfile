return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "dockerfile" } },
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				dockerls = {},
				docker_compose_language_service = {},
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		opts = { ensure_installed = { "dockerfile" } },
	},
	{
		"mason.nvim",
		opts = { ensure_installed = { "hadolint" } },
	},
	{
		"mfussenegger/nvim-lint",
		optional = true,
		opts = {
			linters_by_ft = {
				dockerfile = { "hadolint" },
			},
		},
	},
}
