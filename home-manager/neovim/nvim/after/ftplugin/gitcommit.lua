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

local auto_accept = true

if has('CopilotChat.nvim') then
  local commit_buf = vim.api.nvim_get_current_buf()

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

        if auto_accept then
          -- Extract commit message from markdown code blocks if present
          local commit_msg = response.content:match('```.-\n(.-)```') or response.content
          -- Trim whitespace
          commit_msg = commit_msg:match('^%s*(.-)%s*$')

          -- Replace buffer content with the generated commit message
          local lines = vim.split(commit_msg, '\n', { trimempty = false })
          vim.api.nvim_buf_set_lines(commit_buf, 0, -1, false, lines)

          -- Close CopilotChat
          chat.close()
        end

        return response
      end,
    })
  end)
  vim.api.nvim_create_autocmd('QuitPre', {
    command = 'CopilotChatClose',
  })
end
