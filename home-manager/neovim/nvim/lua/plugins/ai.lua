return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = { 'InsertEnter', 'VeryLazy' },
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        yaml = true,
      },
    },
  },

  {
    'CopilotC-Nvim/CopilotChat.nvim',
    event = 'VeryLazy',
    build = 'make tiktoken',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    config = function()
      local chat = require('CopilotChat')
      local select = require('CopilotChat.select')
      chat.setup({
        chat_autocomplete = false,
        prompts = {
          Commit = {
            prompt = [[
              Write commit message for the change with commitizen convention.
              Keep the title under 50 characters and wrap message at 72 characters.
              Format as a gitcommit code block.
              Do not delete signed-off by or anything that's already written in commit message.
            ]],
            sticky = '#gitdiff:staged',
            selection = select.buffer,
          },
        },
      })
    end,
  },

  {
    'folke/sidekick.nvim',
    opts = {
      cli = {
        ---@class sidekick.cli.Mux
        mux = {
          backend = 'tmux',
          enabled = true,
        },
        ---@type table<string, sidekick.cli.Config|{}>
        tools = {
          opencode = {
            cmd = { 'opencode' },
            -- HACK: https://github.com/sst/opencode/issues/445
            env = { OPENCODE_THEME = 'system' },
          },
        },
      },
    },
    keys = {
      {
        '<leader>ai',
        function()
          require('sidekick.cli').toggle({ name = 'opencode', focus = true })
        end,
        desc = 'Sidekick Toggle OpenCode',
      },
    },
  },
}
