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
    'yetone/avante.nvim',
    build = 'make',
    event = 'VeryLazy',
    lazy = false,
    version = false,
    opts = {
      provider = 'opencode',
      -- provider = 'qwen',
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
      acp_providers = {
        ['opencode'] = {
          command = 'opencode',
          args = { 'acp' },
          env = {
            OPENAI_API_KEY = os.getenv('OPENAI_API_KEY'),
          },
        },
      },
      windows = {
        width = 40,
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
