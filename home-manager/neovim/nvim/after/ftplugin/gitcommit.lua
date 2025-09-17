local has = require('custom.util').has
local commit_bufnr = vim.api.nvim_get_current_buf()

if has('CopilotChat.nvim') then
  vim.keymap.set('n', '<leader>c', '<cmd>CopilotChatCommit<CR>', { buffer = commit_bufnr })
  vim.schedule(function()
    require('CopilotChat')
    vim.cmd.CopilotChatCommit()
  end)
  vim.api.nvim_create_autocmd('QuitPre', {
    command = 'CopilotChatClose',
  })

  vim.keymap.set('ca', 'qq', 'execute \'CopilotChatClose\' <bar> wqa')
end
