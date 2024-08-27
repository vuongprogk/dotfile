local java_filetypes = { "java" }
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
		ft = java_filetypes,
		opts = function()
			local mason_registry = require("mason-registry")
			local lombok_jar = mason_registry.get_package("jdtls"):get_install_path() .. "/lombok.jar"
			return {
				-- How to find the root dir for a given filename. The default comes from
				-- lspconfig which provides a function specifically for java projects.
				root_dir = require("lspconfig.server_configurations.jdtls").default_config.root_dir,

				-- How to find the project name for a given root dir.
				project_name = function(root_dir)
					return root_dir and vim.fs.basename(root_dir)
				end,

				-- Where are the config and workspace dirs for a project?
				jdtls_config_dir = function(project_name)
					return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
				end,
				jdtls_workspace_dir = function(project_name)
					return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
				end,

				-- How to run jdtls. This can be overridden to a full java command-line
				-- if the Python wrapper script doesn't suffice.
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

				-- These depend on nvim-dap, but can additionally be disabled by setting false here.
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
			-- Find the extra bundles that should be passed on the jdtls command-line
			-- if nvim-dap is enabled with java debug/test.
			local mason_registry = require("mason-registry")
			local bundles = {} ---@type string[]
			if opts.dap and Ace.has("nvim-dap") and mason_registry.is_installed("java-debug-adapter") then
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
					capabilities = Ace.has("cmp-nvim-lsp") and require("cmp_nvim_lsp").default_capabilities() or nil,
				}, opts.jdtls)

				-- Existing server will be reused if the root_dir matches.
				require("jdtls").start_or_attach(config)
				-- not need to require("jdtls.setup").add_commands(), start automatically adds commands
			end

			-- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
			-- depending on filetype, so this autocmd doesn't run for the first file.
			-- For that, we call directly below.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = java_filetypes,
				callback = attach_jdtls,
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					if client and client.name == "jdtls" then
						if opts.dap and Ace.has("nvim-dap") and mason_registry.is_installed("java-debug-adapter") then
							-- custom init for Java debugger
							require("jdtls").setup_dap(opts.dap)
							require("jdtls.dap").setup_dap_main_class_configs(opts.dap_main)
						end

						-- User can set additional keymaps in opts.on_attach
						if opts.on_attach then
							opts.on_attach(args)
						end
					end
				end,
			})

			attach_jdtls()
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			-- make sure mason installs the server
			servers = {
				jdtls = {

					handlers = {
						["$/progress"] = function() end,
					},
				},
			},
			setup = {
				jdtls = function()
					local is_maven_project = vim.fs.find({ "gradlew", "mvnw", "pom.xml" }, { upward = true })[1]
					-- NOTE: if cwd is maven project then not start local jdtls instead using nvim jdtls
					if is_maven_project then
						return true
					end
					return false
				end,
			},
		},
	},
	{
		"mfussenegger/nvim-dap",
		optional = true,
		dependencies = {
			{
				"williamboman/mason.nvim",
				opts = { ensure_installed = { "java-debug-adapter", "java-test" } },
			},
		},
	},
}
