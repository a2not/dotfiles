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
    'olimorris/codecompanion.nvim',
    cmd = 'CodeCompanion',
    keys = {
      { '<leader>at', '<cmd>CodeCompanionChat Toggle<cr>', desc = 'Toggle CodeCompanion chat' },
      { '<leader>aa', '<cmd>CodeCompanionChat Add<cr>', desc = 'Add to CodeCompanion chat', mode = 'x' },
    },
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    opts = function()
      local config = require('codecompanion.config').config

      local diff_opts = config.display.diff.opts
      table.insert(diff_opts, 'context:99') -- Setting the context to a very large number disables folding.

      return {
        strategies = {
          chat = { adapter = 'copilot' },
          inline = {
            adapter = 'copilot',
            keymaps = {
              accept_change = {
                modes = { n = '<leader>ay' },
                description = 'Accept the suggested change',
              },
              reject_change = {
                modes = { n = '<leader>an' },
                description = 'Reject the suggested change',
              },
            },
          },
        },
        display = {
          diff = { opts = diff_opts },
        },
      }
    end,
  },

  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = false,
    opts = {
      provider = 'copilot',
      auto_suggestions_provider = 'copilot',
      behaviour = {
        auto_suggestions = false,
        auto_set_highlight_group = true,
        auto_set_keymaps = true,
        auto_apply_diff_after_generation = true,
        support_paste_from_clipboard = true,
        minimize_diff = true,
      },
      windows = {
        position = 'right',
        wrap = true,
        width = 40,
        sidebar_header = {
          enabled = true,
          align = 'center',
          rounded = true,
        },
        input = {
          prefix = '> ',
          height = 8,
        },
        edit = {
          border = 'rounded',
          start_insert = true,
        },
        ask = {
          floating = true,
          start_insert = true,
          border = 'rounded',
          focus_on_apply = 'ours',
        },
      },
      file_selector = {
        provider = 'telescope',
      },
    },
    build = 'make',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'zbirenbaum/copilot.lua',
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'Avante' },
        },
        ft = { 'Avante' },
      },
    },
  },
}
