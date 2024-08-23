local function extend_or_override(config, custom, ...)
	if type(custom) == "function" then
		config = custom(config, ...) or config
	elseif custom then
		config = vim.tbl_deep_extend("force", config, custom) --[[@as table]]
	end
	return config
end
return {
	{
		"mfussenegger/nvim-jdtls",
		cond = vim.fs.find({ "gradlew", "mvnw", "pom.xml" }, { upward = true })[1] and true or false,
		ft = "java",
		opts = function()
			local mason_registry = require("mason-registry")
			local lombok_jar = mason_registry.get_package("jdtls"):get_install_path() .. "/lombok.jar"
			return {
				root_dir = require("lspconfig.server_configurations.jdtls").default_config.root_dir,

				project_name = function(root_dir)
					return root_dir and vim.fs.basename(root_dir)
				end,

				jdtls_config_dir = function(project_name)
					return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
				end,
				jdtls_workspace_dir = function(project_name)
					return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
				end,

				cmd = {
					vim.fn.exepath("jdtls"),
					string.format("--jvm-arg=-javaagent:%s", lombok_jar),
				},
				full_cmd = function(opts)
					local fname = vim.api.nvim_buf_get_name(0)
					local root_dir = opts.root_dir(fname)
					local project_name = opts.project_name(root_dir)
					local cmd = vim.deepcopy(opts.cmd)
					if project_name then
						vim.list_extend(cmd, {
							"-configuration",
							opts.jdtls_config_dir(project_name),
							"-data",
							opts.jdtls_workspace_dir(project_name),
						})
					end
					return cmd
				end,

				dap = { hotcodereplace = "auto", config_overrides = {} },
				dap_main = {},
				test = true,
				settings = {
					java = {
						inlayHints = {
							parameterNames = {
								enabled = "all",
							},
						},
					},
				},
			}
		end,
		config = function(_, opts)
			local mason_registry = require("mason-registry")
			local bundles = {} ---@type string[]
			if
				opts.dap
				and require("lazy.core.config").plugins["nvim-dap"]._.installed
				and mason_registry.is_installed("java-debug-adapter")
			then
				local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
				local java_dbg_path = java_dbg_pkg:get_install_path()
				local jar_patterns = {
					java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
				}
				-- java-test also depends on java-debug-adapter.
				if opts.test and mason_registry.is_installed("java-test") then
					local java_test_pkg = mason_registry.get_package("java-test")
					local java_test_path = java_test_pkg:get_install_path()
					vim.list_extend(jar_patterns, {
						java_test_path .. "/extension/server/*.jar",
					})
				end
				for _, jar_pattern in ipairs(jar_patterns) do
					for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
						table.insert(bundles, bundle)
					end
				end
			end
			require("ace.core.lspmapping")
			local function attach_jdtls()
				local fname = vim.api.nvim_buf_get_name(0)

				-- Configuration can be augmented and overridden by opts.jdtls
				local config = extend_or_override({
					cmd = opts.full_cmd(opts),
					root_dir = opts.root_dir(fname),
					init_options = {
						bundles = bundles,
					},
					settings = opts.settings,
					-- enable CMP capabilities
					capabilities = require("lazy.core.config").plugins["nvim-dap"]._.installed and require(
						"cmp_nvim_lsp"
					).default_capabilities() or nil,
				}, opts.jdtls)

				-- Existing server will be reused if the root_dir matches.
				require("jdtls").start_or_attach(config)
				-- not need to require("jdtls.setup").add_commands(), start automatically adds commands
			end
			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = attach_jdtls,
			})
		end,
	},
}
