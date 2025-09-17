return {
  {
    'folke/todo-comments.nvim',
    event = 'VeryLazy',
    cmd = { 'TodoTrouble', 'TodoTelescope' },
    config = true,
    keys = {
      {
        ']t',
        function()
          require('todo-comments').jump_next()
        end,
        mode = 'n',
        desc = 'TODO jump next',
      },
      {
        '[t',
        function()
          require('todo-comments').jump_prev()
        end,
        mode = 'n',
        desc = 'TODO jump prev',
      },
      {
        '<leader>ft',
        [[<cmd>TodoTelescope<cr>]],
        mode = 'n',
        desc = 'workspace TODOs in Telescope',
      },
    },
    -- FIX:
    -- TODO:
    -- HACK:
    -- WARN:
    -- PERF:
    -- NOTE:
    -- TEST:
  },

  {
    'folke/trouble.nvim',
    cmd = { 'Trouble' },
    opts = {},
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle focus=true<cr>', desc = 'Diagnostics (Trouble)' },
    },
  },
}
