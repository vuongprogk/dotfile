return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		linters_by_ft = {
			cpp = { "cpplint" },
			lua = { "luacheck" },
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			svelte = { "eslint_d" },
			python = { "pylint" },
			-- TODO create .vale.init
			-- using this link to generate profile https://vale.sh/generator
			-- run cmd vale sync to create style folder
			markdown = { "markdownlint", "vale" },
		},
	},
	config = function()
		local lint = require("lint")
		-- TODO create auto command ran after Buffer Wrote
		vim.keymap.set("n", "<leader>l", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
