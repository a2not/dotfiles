local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  spec = 'plugins',
  install = {
    colorscheme = { 'tokyonight' },
  },
  ui = {
    border = 'rounded',
  },
  change_detection = {
    enabled = true, -- automatically check for config file changes and reload the ui. (same as default of true)
    notify = false, -- get a notification when changes are found
  },
})

vim.keymap.set('n', '<leader>l', [[<Cmd>Lazy<CR>]], { desc = 'Open Lazy' })
