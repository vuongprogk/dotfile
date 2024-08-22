local opt = vim.opt
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Turn off bell
opt.belloff = "all"

-- set default background
opt.background = "dark"
opt.termguicolors = true

--set croll off
opt.scrolloff = 10

-- show number
opt.number = true
opt.relativenumber = true

-- set tabsize
opt.expandtab = true
opt.autoindent = true
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
opt.cursorline = true

-- set copy direct to clipboard
opt.clipboard:append("unnamedplus")
opt.ignorecase = true
opt.smartcase = true

-- set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.g.updatetime = 200
opt.autowrite = true -- Enable auto write
opt.confirm = true
opt.undolevels = 10000

if vim.fn.has("nvim-0.10") == 1 then
	opt.smoothscroll = true
end

opt.showmode = false -- Dont show mode since we have a statusline

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
opt.spelllang = { "en" }
opt.spelloptions:append("noplainbuffer")

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.inccommand = "nosplit" -- preview incremental substitute
opt.pumblend = 0 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup

opt.shiftround = true -- Round indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })

-- set keymap for tab
vim.keymap.set("n", "<Leader>tn", "<cmd>tabnext<CR>", { silent = true })
vim.keymap.set("n", "<Leader>tp", "<cmd>tabprevious<CR>", { silent = true })
