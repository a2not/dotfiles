vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
  group = vim.api.nvim_create_augroup('HighlightYank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 100,
    })
  end,
  desc = 'Highlight Yanked code range',
})

vim.api.nvim_create_autocmd('BufEnter', {
  pattern = '*.templ',
  callback = function()
    vim.cmd('TSBufEnable highlight')
  end,
})

-- vim.api.nvim_create_autocmd(
--   { 'BufWritePost' },
--   {
--     group = vim.api.nvim_create_augroup('ProtobufFormat', { clear = true }),
--     command = 'silent! !clang-format -i <afile>',
--     pattern = '*.proto',
--     desc = 'FormatOnSave .proto file with clang-format',
--   }
-- )
