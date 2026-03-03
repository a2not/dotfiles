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
    enabled = false,
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
          create = 'split',
        },
      },
    },
    keys = {
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

  {
    'nickjvandyke/opencode.nvim',
    version = '*', -- Latest stable release
    dependencies = {
      {
        'folke/snacks.nvim',
        optional = true,
      },
    },
    config = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        -- Your configuration, if any; goto definition on the type or field for details
      }
      vim.o.autoread = true -- Required for `opts.events.reload`
    end,
    keys = {
      {
        '<C-a>',
        function()
          require('opencode').ask('@this: ', { submit = true })
        end,
        mode = { 'x', 'n' },
        desc = 'Ask opencode…',
      },
      {
        '<C-x>',
        function()
          require('opencode').select()
        end,
        mode = { 'x', 'n' },
        desc = 'Execute opencode action…',
      },
      {
        '<C-.>',
        function()
          require('opencode').toggle()
        end,
        mode = { 'n', 't' },
        desc = 'Toggle opencode',
      },
      {
        '<S-C-u>',
        function()
          require('opencode').command('session.half.page.up')
        end,
        mode = { 'n' },
        desc = 'Scroll opencode up',
      },
      {
        '<S-C-d>',
        function()
          require('opencode').command('session.half.page.down')
        end,
        mode = { 'n' },
        desc = 'Scroll opencode down',
      },
    },
  },
}
