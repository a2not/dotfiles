return {
  {
    'stevearc/oil.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      {
        '<leader>e',
        function()
          if vim.bo.filetype == 'oil' then
            vim.cmd.close()
          else
            require('oil').open_float()
          end
        end,
        desc = 'Toggle Oil explorer',
      },
    },
    opts = {
      win_options = {
        signcolumn = 'yes:2',
      },
      view_options = {
        show_hidden = true,
      },
      float = {
        padding = 2,
        max_width = 3 / 4,
        max_height = 3 / 4,
      },
      keymaps = {
        ['<Esc>'] = 'actions.close',
        ['-'] = { 'actions.parent', mode = 'n' },
        ['_'] = { 'actions.open_cwd', mode = 'n' },
      },
    },
    config = true,
  },
  {
    'refractalize/oil-git-status.nvim',
    dependencies = {
      'stevearc/oil.nvim',
    },

    config = true,
  },
}
