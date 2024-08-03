return {
	{
		"numToStr/FTerm.nvim",
		event = "VimEnter",
		enabled = function()
			if require("ace.custom.os").getName() == "Windows" then
				return false
			end
			return true
		end,

		config = function()
			local term = require("FTerm")
			vim.keymap.set({ "n", "i", "t" }, "<C-\\>", term.toggle, { desc = "Toogle FTerm" })
			term.setup({
				blend = 0,
				cmd = function()
					if require("ace.custom.os").getName() == "Windows" then
						return "powershell"
					else
						return nil
					end
				end,
			})
			local lazygit = term:new({

				ft = "fterm_lazygit", -- You can also override the default filetype, if you want
				cmd = "lazygit",
				dimensions = {
					height = 0.9,
					width = 0.9,
				},
			})
			vim.keymap.set({ "n" }, "<leader>lg", function()
				lazygit:toggle()
			end, { desc = "Togle lazygit" })
		end,
	},
	{
		"akinsho/toggleterm.nvim",
		event = "VeryLazy",
		enabled = function()
			if require("ace.custom.os").getName() == "Windows" then
				return true
			end
			return false
		end,
		version = "*",
		opts = {
			autochdir = true,
			open_mapping = [[<c-\>]],
			size = function(term)
				if term.direction == "horizontal" then
					return 15
				elseif term.direction == "vertical" then
					return vim.o.columns * 0.4
				end
			end,
			direction = "tab", -- "horizontal", -- | "tab" | "float",
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)
			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

			function _lazygit_toggle()
				lazygit:toggle()
			end

			vim.api.nvim_set_keymap(
				"n",
				"<leader>lg",
				"<cmd>lua _lazygit_toggle()<CR>",
				{ noremap = true, silent = true }
			)
		end,
	},
}
