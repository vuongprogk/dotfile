return {
	{
		"mfussenegger/nvim-dap",
		cmd = {
			"DapToggleBreakpoint",
			"DapContinue",
		},
		keys = {
			{
				"<Leader>dt",
				"<cmd>DapToggleBreakpoint<CR>",
				{ desc = "Toggle breakpoint", mode = { "n", "v" } },
			},
			{
				"<Leader>dc",
				"<cmd>DapContinue<CR>",
				{ desc = "Start/Continue debugger", mode = { "n", "v" } },
			},
		},
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
			"rcarriga/nvim-dap-ui",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local present, dap = pcall(require, "dap")
			if not present then
				vim.notify("DAP not loaded")
				return
			end

			local dapui = require("dapui")
			require("dapui").setup()

			--TODO Update DAP icons and color

			--Update dap icon
			-- vim.api.nvim_set_hl(0, "red", { fg = "#FFA500" })
			-- vim.api.nvim_set_hl(0, "green", { fg = "#9ece6a" })
			-- vim.api.nvim_set_hl(0, "yellow", { fg = "#FFFF00" })
			-- vim.api.nvim_set_hl(0, "orange", { fg = "#f09000" })
			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				desc = "prevent colorscheme clears self-defined DAP icon colors.",
				callback = function()
					vim.api.nvim_set_hl(0, "DapBreakpoint", { ctermbg = 0, fg = "#993939" })
					vim.api.nvim_set_hl(0, "DapLogPoint", { ctermbg = 0, fg = "#61afef" })
					vim.api.nvim_set_hl(0, "DapStopped", { ctermbg = 0, fg = "#98c379" })
				end,
			})

			--Change icons
			vim.fn.sign_define("DapBreakpoint", {
				text = "●",
				texthl = "DapBreakpoint",
				linehl = "DapBreakpoint",
				numhl = "DapBreakpoint",
			})
			vim.fn.sign_define("DapBreakpointCondition", {
				text = "●",
				texthl = "DapBreakpoint",
				linehl = "DapBreakpoint",
				numhl = "DapBreakpoint",
			})
			vim.fn.sign_define("DapBreakpointRejected", {
				text = "◆",
				texthl = "DapBreakpoint",
				linehl = "DapBreakpoint",
				numhl = "DapBreakpoint",
			})
			vim.fn.sign_define("DapStopped", {
				text = "●",
				texthl = "DapStopped",
				linehl = "DapStopped",
				numhl = "DapStopped",
			})
			vim.fn.sign_define("DapLogPoint", {
				text = "󰁕",
				texthl = "DapLogPoint",
				linehl = "DapLogPoint",
				numhl = "DapLogPoint",
			})

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
			vim.keymap.set("n", "<leader>du", function()
				dapui.toggle({})
			end, { desc = "Dap Toggle UI" })
		end,
	},
}
