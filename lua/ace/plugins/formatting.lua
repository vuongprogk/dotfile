return {
	"stevearc/conform.nvim",
	event = { "BufRead", "BufNewFile" },
	keys = {
		{
			"<leader>gf",
			function()
				require("conform").format({
					timeout_ms = 500,
					lsp_format = "fallback",
				})
			end,
			{
				desc = "formatting code",
				mode = { "n", "v" },
			},
		},
	},
	init = function()
		vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
			callback = function()
				vim.filetype.add({
					extension = {
						ejs = "html",
					},
				})
			end,
		})
	end,
	opts = {
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
			cs = { "csharpier", lsp_format = "never" },
			css = { "prettier" },
			cshtml = { "prettier", "prettier", stop_after_first = true },
		},
		format_on_save = {
			lsp_format = "fallback",
			timeout_ms = 500,
		},
	},
}
