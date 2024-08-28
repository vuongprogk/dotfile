return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	cmd = { "NvimTreeFindFileToggle", "NvimTreeToggle", "NvimTreeRefresh" },
	keys = {
		{
			"<leader>fe",
			function()
				require("nvim-tree.api").tree.toggle({
					path = "<args>",
					update_root = "<bang>",
					find_file = true,
					focus = true,
				})
			end,
			desc = "Toggle file explorer on current file",
			remap = true,
		},
		{
			"<leader>ee",
			function()
				require("nvim-tree.api").tree.toggle({
					path = "<args>",
					find_file = false,
					update_root = false,
					focus = true,
				})
			end,
			desc = "Toggle file explorer",
			remap = true,
		},
		{
			"<leader>er",
			function()
				require("nvim-tree.api").tree.refresh()
			end,
			desc = "Refresh file explorer",
			remap = true,
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("BufEnter", {
			group = vim.api.nvim_create_augroup("Neotree_start_directory", { clear = true }),
			desc = "Start Nvim-Tree with directory",
			once = true,
			callback = function()
				if package.loaded["nvim-tree"] then
					return
				else
					local stats = vim.uv.fs_stat(vim.fn.argv(0))
					if stats and stats.type == "directory" then
						require("nvimtree")
					end
				end
			end,
		})
	end,
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
					folder = {
						enable = true,
					},
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
			remove_file = {
				close_window = true,
			},
		},
		filters = {
			custom = { ".DS_Store" },
		},
		on_attach = function(bufnr)
			local api = require("nvim-tree.api")
			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end
			api.config.mappings.default_on_attach(bufnr)

			vim.keymap.set("n", "l", api.node.open.preview, opts("Open Preview"))
			vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
		end,
	},
}
