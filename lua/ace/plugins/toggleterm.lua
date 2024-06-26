return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{
			"<c-\\>",
			function(opts)
				require("toggleterm").toggle_command(opts.args, opts.count)
			end,
			{ desc = "Toggle Term", mode = { "n", "v" } },
		},
	},
	config = function()
		require("toggleterm").setup({
			size = 20,
			open_mapping = [[<c-\>]],
			hide_numbers = true, -- hide the number column in toggleterm buffers
			shade_terminals = true,
			shading_factor = "2",
			start_in_insert = true,
			insert_mappings = true, -- whether or not the open mapping applies in insert mode
			persist_size = true,
			direction = "horizontal",
			close_on_exit = true, -- close the terminal window when the process exits
			shell = "PowerShell",
			auto_scroll = true, -- automatically scroll to the bottom on terminal output
			float_opts = {
				border = "curved",
				title_pos = "center",
			},
		})
		function _G.set_terminal_keymaps()
			vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], { buffer = 0 })
			vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], { buffer = 0 })
			vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], { buffer = 0 })
			vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], { buffer = 0 })
			vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], { buffer = 0 })
			vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], { buffer = 0 })
		end

		vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
	end,
}
