return {
	{
		"mfussenegger/nvim-jdtls",
		cond = vim.fs.find({ "gradlew", "mvnw", "pom.xml" }, { upward = true })[1] and true or false,
		event = "VeryLazy",
		config = function()
			local mason_registry = require("mason-registry")
			local lombok_jar = mason_registry.get_package("jdtls"):get_install_path() .. "/lombok.jar"
			local function attach_jdtls()
				local root = vim.fs.dirname(vim.fs.find({
					"gradlew",
					".git",
					"mvnw", -- Spring
					"build.xml", -- Ant
					"pom.xml", -- Maven
					"settings.gradle", -- Gradle
					"settings.gradle.kts", -- Gradle
				}, { upward = true })[1])
				local project_name = vim.fs.basename(root)

				local config = {
					cmd = {

						vim.fn.exepath("jdtls"),
						string.format("--jvm-arg=-javaagent:%s", lombok_jar),
						"-configuration",
						vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config",
						"-data",
						vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace",
					},
					root_dir = root,
					single_file_support = false,
					settings = {
						java = {
							inlayHints = {
								parameterNames = {
									enabled = "all",
								},
							},
						},
					},
					handlers = {
						["$/progress"] = function() end,
					},
					capabilities = require("lazy.core.config").plugins["cmp-nvim-lsp"]._.installed ~= nil and require(
						"cmp_nvim_lsp"
					).default_capabilities() or nil,
				}
				require("jdtls").start_or_attach(config)
			end
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = attach_jdtls,
			})
		end,
	},
}
