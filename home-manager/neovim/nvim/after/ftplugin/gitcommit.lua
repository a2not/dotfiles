local has = require('custom.util').has

local function get_signed_off_by()
  local handle = io.popen('git var GIT_COMMITTER_IDENT 2>/dev/null')
  if not handle then
    return nil
  end
  local result = handle:read('*a')
  handle:close()

  -- Parse "Name <email> timestamp timezone" format
  local name_email = result:match('^(.-) [0-9]+')
  if not name_email then
    return nil
  end

  return 'Signed-off-by: ' .. name_email
end

if has('CopilotChat.nvim') then
  vim.schedule(function()
    local chat = require('CopilotChat')
    chat.ask('/Commit', {
      callback = function(response)
        -- Append signed-off-by at the end of the message
        local sob = get_signed_off_by()
        if sob then
          -- Insert SOB before the closing ``` or append if not found
          response.content = response.content:gsub('\n```$', '\n\n' .. sob .. '\n```')
        end
        return response
      end,
    })
  end)
  vim.api.nvim_create_autocmd('QuitPre', {
    command = 'CopilotChatClose',
  })
end
