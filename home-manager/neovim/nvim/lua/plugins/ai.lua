return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    event = 'VeryLazy',
    build = 'make tiktoken',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    opts = {
      chat_autocomplete = false,
    },
  },

  {
    'folke/sidekick.nvim',
    cmd = 'Sidekick',
    opts = {
      nes = {
        enabled = false,
      },
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
          },
        },
      },
    },
    keys = {
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle({ name = 'opencode', focus = true })
        end,
        desc = 'Sidekick Toggle opencode',
      },
      {
        '<leader>at',
        function()
          require('sidekick.cli').send({ name = 'opencode', msg = '{this}' })
        end,
        mode = { 'x', 'n' },
        desc = 'Send This',
      },
    },
  },
}
