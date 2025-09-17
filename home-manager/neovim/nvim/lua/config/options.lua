vim.g.mapleader = ' '

-- vim.cmd('language en_US.UTF-8') but it might
-- E5108: Error executing lua vim/_editor.lua:0: pre-vimrc command line..script nvim_exec2() called at pre-vimrc command line:0, line 1: Vim(language):E197: Cannot set language to "en_US.UTF-8"
pcall(vim.cmd.language, 'en_US.UTF-8')

vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'

vim.opt.number = true
vim.opt.relativenumber = true

vim.g.errorbells = false
vim.opt.mouse = ''

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smarttab = true

vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.breakindent = true

vim.opt.wrap = false

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv('HOME') .. '/.vim/undodir'
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = 'split'
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.shell = 'zsh'

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append('@-@')

vim.opt.showcmd = true
-- Give more space for displaying messages.
vim.opt.cmdheight = 0

vim.opt.winborder = 'rounded'

-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
-- delays and poor user experience.
vim.opt.updatetime = 500

-- which-key related timeout configs
vim.o.timeout = true
vim.o.timeoutlen = 300

-- disable netrw
vim.g.loaded_netrw = true
vim.g.loaded_netrwPlugin = true

vim.opt.path:append({ '**' }) -- Finding files - Search down into subfolders
vim.opt.wildignore:append({ '*/node_modules/*' })

-- for nvim-cmp ins-completion
vim.opt.completeopt = { 'menu', 'menuone', 'noinsert', 'noselect' }

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
-- for indent_blankline.nvim simple UI
-- NOTE: disabled as it messes with the link, appending '%E2%86%B4' at the end of every url
-- vim.opt.listchars:append('eol:↴')

vim.filetype.add({ extension = { templ = 'templ' } })
