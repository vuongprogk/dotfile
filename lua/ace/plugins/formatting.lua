return {
	"stevearc/conform.nvim",
	keys = {
		{
			"<leader>gf",
			function()
				require("conform").format()
			end,
			{
				desc = "formatting code",
				mode = { "n", "v" },
			},
		},
	},
	opts = {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { { "prettierd", "prettier" } },
			java = {
				"clang_format",
			},
			cpp = {
				"clang_format",
			},
		},
	},
	format_on_save = {
		timeout_ms = 500,
		lsp_format = "fallback",
	},
}
