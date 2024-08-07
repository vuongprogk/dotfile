return {
	"stevearc/conform.nvim",
	event = { "BufRead", "BufNewFile" },
	keys = {
		{
			"<leader>gf",
			function()
				require("conform").format({ timeout_ms = 1000, lsp_format = "first" })
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
			javascript = { { "prettierd", "prettier" } },
			javascriptreact = { { "prettierd", "prettier" } },

			java = {
				"clang_format",
			},
			cpp = {
				"clang_format",
			},
			html = { "prettier" },
			cs = { "csharpier" },
			css = { "prettier" },
			cshtml = { "csharpier", "prettier" },
		},
		-- format_on_save = {
		-- 	timeout_ms = 500,
		-- 	lsp_format = "first",
		-- },
		format_on_save = {
			lsp_format = "first",
			timeout_ms = 500,
		},
		formatters = {
			csharpier = {
				command = "dotnet-csharpier",
				args = { "--write-stdout", "--no-cache", "$FILENAME" },
			},
		},
	},
}
