return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
  },

  {
    'MeanderingProgrammer/treesitter-modules.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      -- ensure_installed = 'all' -- NOTE: handled by nix
      highlight = { enable = true },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = '<CR>',
          node_incremental = '<CR>',
          scope_incremental = '<TAB>',
          node_decremental = '<BS>',
        },
      },
    },
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },

  {
    'm-demare/hlargs.nvim',
    config = true,
  },

  {
    'andymass/vim-matchup',
  },

  {
    'windwp/nvim-ts-autotag',
    config = true,
  },

  {
    'RRethy/vim-illuminate',
    lazy = true,
    config = function()
      require('illuminate').configure({
        under_cursor = false,
        delay = 200,
        large_file_cutoff = 2000,
        large_file_overrides = {
          providers = {
            'lsp',
            'treesitter',
          },
        },
      })
    end,
    keys = {
      {
        '<leader>n',
        function()
          require('illuminate').goto_next_reference()
        end,
        mode = 'n',
        desc = 'illuminate goto_next_reference',
      },
      {
        '<leader>N',
        function()
          require('illuminate').goto_prev_reference()
        end,
        mode = 'n',
        desc = 'illuminate goto_prev_reference',
      },
    },
  },
}
