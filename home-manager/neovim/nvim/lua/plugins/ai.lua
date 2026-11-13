return {
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    event = 'VeryLazy',
    build = 'make tiktoken',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    init = function()
      vim.api.nvim_create_autocmd('BufWinEnter', {
        pattern = 'copilot-chat',
        callback = function()
          -- Work around Neovim E315 with 'linebreak', conceal, and virtual lines below EOF.
          -- https://github.com/neovim/neovim/pull/42664
          vim.opt_local.linebreak = false
        end,
      })
    end,
    opts = {
      chat_autocomplete = false,
      model = 'gpt-6-luna',
    },
  },
}
