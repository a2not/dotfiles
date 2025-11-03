local has = require('custom.util').has

if has('CopilotChat.nvim') then
  vim.schedule(function()
    require('CopilotChat')
    vim.cmd.CopilotChatCommit()
  end)
  vim.api.nvim_create_autocmd('QuitPre', {
    command = 'CopilotChatClose',
  })
end
