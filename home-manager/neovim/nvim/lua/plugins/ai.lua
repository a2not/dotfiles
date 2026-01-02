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
            -- HACK: https://github.com/sst/opencode/issues/445
            env = { OPENCODE_THEME = 'system' },
          },
        },
      },
    },
    keys = {
      {
        '<tab>',
        function()
          if not require('sidekick').nes_jump_or_apply() then
            return '<Tab>'
          end
        end,
        expr = true,
        desc = 'Goto/Apply Next Edit Suggestion',
      },
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

  {
    'yetone/avante.nvim',
    -- build = 'make',
    event = 'VeryLazy',
    version = false,
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      provider = 'copilot',
      -- provider = 'opencode', -- not working
      -- provider = 'qwen', -- not working
      providers = {
        qwen = {
          __inherited_from = 'openai',
          api_key_name = 'OPENAI_API_KEY',
          endpoint = 'https://api.ai.sakura.ad.jp/v1',
          model = 'Qwen3-Coder-480B-A35B-Instruct-FP8',
        },
      },
      acp_providers = {
        opencode = {
          command = 'opencode',
          args = { 'acp' },
          env = {
            OPENAI_API_KEY = vim.fn.getenv('OPENAI_API_KEY'),
            LD_LIBRARY_PATH = vim.fn.systemlist('bash -lc \'echo $(nix eval --raw nixpkgs#stdenv.cc.cc.lib)/lib\'')[1],
          },
        },
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
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
