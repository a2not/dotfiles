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
        help = true,
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
    opts = {
      chat_autocomplete = false,
    },
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
          crush = {
            cmd = { 'crush' },
            -- crush uses <a-p> for its own functionality, so we override the default
            keys = { prompt = { '<a-p>', 'prompt' } },
          },
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
        '<leader>ac',
        function()
          require('sidekick.cli').toggle({ name = 'crush', focus = true })
        end,
        desc = 'Sidekick Toggle Crush',
      },
      {
        '<leader>ao',
        function()
          require('sidekick.cli').toggle({ name = 'opencode', focus = true })
        end,
        desc = 'Sidekick Toggle opencode',
      },
    },
  },
}
