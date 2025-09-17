return {
  -- NOTE: shout-out to TJ, the GOAT
  -- https://github.com/nvim-lua/kickstart.nvim
  {
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },

  {
    'mason-org/mason.nvim',
    opts = {},
  },

  {
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      'mason-org/mason.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      'saghen/blink.cmp',

      {
        'j-hui/fidget.nvim',
        opts = {},
      },
    },

    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
          map('gt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')
          map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
          map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
          map('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
          map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        end,
      })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config({
        severity_sort = true,
        float = { border = 'rounded' },
        underline = true,
        jump = { float = true },
      })

      -- NOTE: for installing non-LSP tools such as `stylua`, `goimports`
      require('mason-tool-installer').setup({
        ensure_installed = {
          'eslint',
          'jsonls',
          'lua_ls',
          'stylua',
          'ts_ls',
          'gopls',
          'goimports',
          'gofumpt',
          'golangci_lint_ls',
          'html',
          'templ',
          'rust_analyzer',
          'nil_ls',
          'terraformls',
          'tflint',
          'phpactor',
          'astro',
          'tsp_server',
        },
      })

      require('mason-lspconfig').setup()
    end,
  },
}
