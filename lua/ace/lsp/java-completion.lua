return {
	"mfussenegger/nvim-jdtls",
	ft = "java",
	config = function()
		local os = require("ace.detect.os")
		local path = vim.fn.stdpath("data") .. "\\mason\\bin\\jdtls.cmd" --Default using Windows
		if os.getName() == "Windows" then
			path = vim.fn.stdpath("data") .. "\\mason\\bin\\jdtls.cmd"
    else
      path = ""
		end
		local config = {
			cmd = { vim.fn.expand(path) },
			root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml" }, { upward = true })[1]),
		}
		require("jdtls").start_or_attach(config)
	end,
}
