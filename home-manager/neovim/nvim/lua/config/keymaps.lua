vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader><leader>x', '<Cmd>source %<CR>', { desc = 'source current file' })
vim.keymap.set({ 'n', 'v' }, 'qq', '<Cmd>qa!<CR>', { desc = 'Quit all' })
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]], { desc = 'yank to clipboard' })

vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('x', 'p', [["_dP]], { desc = 'paste without losing yanked buffer' })

vim.keymap.set(
  'n',
  '<leader>rp',
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = 'replace words same as one at cursor, in a file' }
)

vim.keymap.set('v', 'J', [[:m '>+1<CR>gv=gv]]) -- move selected line down
vim.keymap.set('v', 'K', [[:m '<-2<CR>gv=gv]]) -- move selected line up

-- Center buffer while navigating
vim.keymap.set('n', '<C-u>', '<C-u>zz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { noremap = true, silent = true })
vim.keymap.set('n', '{', '{zz', { noremap = true, silent = true })
vim.keymap.set('n', '}', '}zz', { noremap = true, silent = true })
vim.keymap.set('n', 'N', 'Nzz', { noremap = true, silent = true })
vim.keymap.set('n', 'n', 'nzz', { noremap = true, silent = true })
vim.keymap.set('n', 'G', 'Gzz', { noremap = true, silent = true })
vim.keymap.set('n', 'gg', 'ggzz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-i>', '<C-i>zz', { noremap = true, silent = true })
vim.keymap.set('n', '<C-o>', '<C-o>zz', { noremap = true, silent = true })
vim.keymap.set('n', '%', '%zz', { noremap = true, silent = true })
vim.keymap.set('n', '*', '*zz', { noremap = true, silent = true })
vim.keymap.set('n', '#', '#zz', { noremap = true, silent = true })

-- quickfix list
vim.keymap.set('n', '<leader>q', function()
  -- cclose if open, return immediately
  for _, win in pairs(vim.fn.getwininfo()) do
    if win['quickfix'] == 1 then
      vim.cmd.cclose()
      return
    end
  end

  -- else copen
  vim.cmd.copen()
  -- FYI: can be checked if not open by following condition
  -- `if not vim.tbl_isempty(vim.fn.getqflist()) then ... end`
end, { desc = 'toggle Quickfix List' })
