return {
	"mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
	opts = {
		linters_by_ft = {
			cpp = { "cpplint" },
			lua = { "luacheck" },
			python = { "pylint" },
			javascript = { "eslint_d" },
		},
	},
	config = function()
		local lint = require("lint")
		-- TODO create auto command ran after Buffer Wrote
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			callback = function()
				lint.try_lint()
			end,
		})

		vim.api.nvim_create_autocmd({ "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
