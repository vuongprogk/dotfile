return {
	"nvim-tree/nvim-tree.lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		sync_root_with_cwd = true,
		view = {
			width = 35,
		},
		-- change folder arrow icons
		renderer = {
			indent_markers = {
				enable = true,
			},
			icons = {
				web_devicons = {
					file = {
						enable = true,
						color = true,
					},
					folder = {
						enable = false,
						color = true,
					},
				},
				git_placement = "after",
				modified_placement = "after",
				show = {
					git = true,
				},
			},
		},
		actions = {
			open_file = {
				quit_on_open = true,
				window_picker = {
					enable = false,
				},
			},
		},
		filters = {
			custom = { ".DS_Store" },
		},
		git = {
			ignore = false,
		},
		modified = {
			enable = true,
			show_on_dirs = true,
			show_on_open_dirs = true,
		},
	},
	deactivate = function()
		vim.cmd([[NvimTreeClose]])
	end,
	init = function()
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("nvim-tree-start-with-directory", { clear = true }),
			desc = "Start nvimtree with directory",
			once = true,
			callback = function()
				if package.loaded["nvim-tree"] then
					return
				else
					local stats = vim.uv.fs_stat(vim.fn.argv(0))
					if stats and stats.type == "directory" then
						require("nvim-tree")
					end
				end
			end,
		})
	end,
	keys = {
		{
			"<leader>ef",
			"<cmd>NvimTreeFindFileToggle<CR>",
			{ desc = "Toggle file explorer on current file", remap = true, mode = { "n", "v" } },
		},
		{
			"<leader>ee",
			"<cmd>NvimTreeToggle<CR>",
			{ desc = "Toggle file explorer", remap = true, mode = { "n", "v" } },
		},
		{
			"<leader>er",
			"<cmd>NvimTreeRefresh<CR>",
			{ desc = "Refresh file explorer", remap = true, mode = { "n", "v" } },
		},
	},
	cmd = { "NvimTreeFindFileToggle", "NvimTreeToggle", "NvimTreeRefresh" },
}
