return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	config = function()
		local os = require("ace.custom.os")
		local path = vim.fn.stdpath("data") .. "\\mason\\bin\\jdtls.cmd" --Default using Windows
		if os.getName() == "Windows" then
			path = vim.fn.stdpath("data") .. "\\mason\\bin\\jdtls.cmd"
		else
			path = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
		end
		local config = {
			cmd = { vim.fn.expand(path) },
			root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml" }, { upward = true })[1]),
			handlers = {
				["$/progress"] = function(_, result, ctx) end,
			},
		}
		require("jdtls").start_or_attach(config)
	end,
}
