local opt = vim.opt
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Turn off bell
opt.belloff = "all"

vim.g.bigfile_size = 1024 * 1024 * 1.5 -- 1.5 MB
vim.g.root_spec = { "lsp", { ".git", "lua" }, "cwd" }

vim.g.trouble_lualine = true
-- set default background
opt.background = "dark"
opt.termguicolors = true
opt.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
opt.autowrite = true -- Enable auto write

opt.fillchars = {
	foldopen = "",
	foldclose = "",
	fold = " ",
	foldsep = " ",
	diff = "╱",
	eob = " ",
}
opt.linebreak = true -- Wrap lines at convenient points

opt.laststatus = 3 -- global statusline

--set croll off
opt.scrolloff = 10

-- show number
opt.number = true
opt.relativenumber = false

-- set tabsize
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.smartindent = true -- Insert indents automatically

opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current

opt.undofile = true

opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
--set no wrap
opt.wrap = false
opt.signcolumn = "yes"

-- open cursor line
opt.cursorline = false

-- set copy direct to clipboard
opt.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
opt.ignorecase = true
opt.smartcase = true

-- set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.updatetime = 200
opt.undolevels = 10000

opt.showmode = false -- Dont show mode since we have a statusline
opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
opt.winminwidth = 5 -- Minimum window width
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.spelllang = { "en" }
opt.spelloptions:append("noplainbuffer")

opt.formatexpr = "v:lua.require'ace.core.util.format'.formatexpr()"
opt.formatoptions = "jcroqlnt" -- tcqj
opt.statuscolumn = [[%!v:lua.require'ace.core.util.ui'.statuscolumn()]]
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.inccommand = "nosplit" -- preview incremental substitute
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup

opt.shiftround = true -- Round indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.list = true
opt.mouse = "a" -- Enable mouse mode
opt.sidescrolloff = 8 -- Columns of context

if vim.fn.has("nvim-0.10") == 1 then
	opt.smoothscroll = true
end
opt.ttyfast = true

vim.opt.backup = true
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup"

vim.g.autoformat = true

vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
