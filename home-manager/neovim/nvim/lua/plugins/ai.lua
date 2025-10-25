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
          crush = {
            cmd = { 'crush' },
            keys = { prompt = { '<a-p>', 'prompt' } },
          },
        },
      },
    },
    keys = {
      {
        '<leader>aa',
        function()
          require('sidekick.cli').toggle({ name = 'crush', focus = true })
        end,
        desc = 'Sidekick Toggle Crush',
      },
    },
  },

  {
    'yetone/avante.nvim',
    build = 'make',
    event = 'VeryLazy',
    lazy = false,
    version = false,
    opts = {
      provider = 'qwen',
      -- provider = 'copilot',
      auto_suggestions_provider = 'qwen',
      providers = {
        qwen = {
          __inherited_from = 'openai',
          api_key_name = 'OPENAI_API_KEY',
          endpoint = 'https://api.ai.sakura.ad.jp/v1',
          model = 'Qwen3-Coder-480B-A35B-Instruct-FP8',
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
      },
      windows = {
        width = 40,
        ask = {
          floating = true,
        },
      },
      file_selector = {
        provider = 'telescope',
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'zbirenbaum/copilot.lua',
      'nvim-telescope/telescope.nvim',
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
  },
}
