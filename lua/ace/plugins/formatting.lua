return {
	{
		"jay-babu/mason-null-ls.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"nvimtools/none-ls.nvim",
		},
		config = function()
			require("mason-null-ls").setup({
				ensure_installed = { "stylua", "pylint", "isort", "black", "prettier", "clang_format", "cpplint" },
				automatic_installation = true,
			})
		end,
	},
	-- setup formatting
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.diagnostics.pylint.with({
						diagnostics_postprocess = function(diagnostic)
							diagnostic.code = diagnostic.message_id
						end,
					}),
					null_ls.builtins.formatting.isort,
					null_ls.builtins.formatting.black,
					null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.clang_format,
				},
			})
			vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { silent = true })
		end,
	},
}
