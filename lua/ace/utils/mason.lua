return {
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		opts_extend = { "ensure_installed" },
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
			ensure_installed = {
				"stylua",
				"eslint_d",
				"cpplint",
				"pylint",
				"luacheck",
				"black",
				"isort",
				"prettier",
				"prettierd",
				"clang-format",
			},
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			mr:on("package:install:success", function()
				vim.defer_fn(function()
					-- trigger FileType event to possibly load this newly installed LSP server
					require("lazy.core.handler.event").trigger({
						event = "FileType",
						buf = vim.api.nvim_get_current_buf(),
					})
				end, 100)
			end)

			mr.refresh(function()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end)
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		cmd = { "DapInstall", "DapUninstall" },
		dependencies = {
			"williamboman/mason.nvim",
		},
		opts = {
			ensure_installed = {
				"cppdbg",
				"javadbg",
			},
			handlers = {
				function(config)
					return require("mason-nvim-dap").default_setup(config)
				end,
				cppdbg = function(config)
					config.configurations = {
						{
							name = "cppdbg: Launch file",
							type = "cppdbg",
							request = "launch",
							program = function()
								return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
							end,
							cwd = "${workspaceFolder}",
							stopAtEntry = true,
						},
						{
							name = "cppdbg: Attach to gdbserver :1234",
							type = "cppdbg",
							request = "launch",
							MIMode = "gdb",
							miDebuggerServerAddress = "localhost:1234",
							miDebuggerPath = vim.fn.exepath("gdb"),
							cwd = "${workspaceFolder}",
							program = function()
								return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
							end,
						},
					}
					require("mason-nvim-dap").default_setup(config)
				end,
			},
		},
	},
}
