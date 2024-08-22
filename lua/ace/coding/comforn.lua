return {
	"stevearc/conform.nvim",
	event = { "BufRead", "BufNewFile" },
	keys = {
		{
			"<leader>cF",
			function()
				require("conform").format({
					timeout_ms = 3000,
				})
			end,
			{
				desc = "Formatting code mannually",
				mode = { "n", "v" },
				remap = true,
			},
		},
	},
	opts = {
		default_format_opts = {
			timeout_ms = 3000,
			async = false, -- not recommended to change
			quiet = false, -- not recommended to change
			lsp_format = "fallback", -- not recommended to change
		},
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { "prettier", "prettierd", stop_after_first = true },
			javascriptreact = { "prettier", "prettierd", stop_after_first = true },

			java = {
				"clang_format",
			},
			cpp = {
				"clang_format",
			},
			html = { "prettier" },
			cs = { "csharpier" },
			css = { "prettier" },
			cshtml = { "prettier", "prettier", stop_after_first = true },
		},
		formatters = {
			csharpier = {
				command = "dotnet-csharpier",
				args = { "--write-stdout" },
			},
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 500,
		},
	},
}
