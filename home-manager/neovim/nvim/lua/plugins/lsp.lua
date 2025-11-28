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
    'mason-org/mason-lspconfig.nvim',
    dependencies = {
      'neovim/nvim-lspconfig',
      {
        'mason-org/mason.nvim',
        opts = {},
      },

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

          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
          map('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')
          map('K', vim.lsp.buf.hover, 'Hover Documentation')

          -- with picker
          map('gd', Snacks.picker.lsp_definitions, '[G]oto [D]efinition')
          map('gD', Snacks.picker.lsp_declarations, '[G]oto [D]eclaration')
          map('gt', Snacks.picker.lsp_type_definitions, '[G]oto [T]ype Definition')
          map('gi', Snacks.picker.lsp_implementations, '[G]oto [I]mplementation')
          map('gr', Snacks.picker.lsp_references, '[G]oto [R]eferences')
          map('<leader>ss', Snacks.picker.lsp_symbols, '[S]earch LSP [S]ymbols')
          map('<leader>ws', Snacks.picker.lsp_workspace_symbols, '[W]orkspace LSP [S]ymbols')
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
          'copilot',
          'eslint',
          'jsonls',
          'ts_ls',
          'gopls',
          'goimports',
          'gofumpt',
          'golangci_lint_ls',
          'html',
          'templ',
          'rust_analyzer',
          'nil_ls',
          'alejandra',
          'terraformls',
          'tflint',
          'intelephense',
          'astro',
          'tsp_server',
        },
      })

      require('mason-lspconfig').setup()

      -- NOTE: installed by nix. manually enable here.
      -- > "Could not start dynamically linked executable: stylua
      --    NixOS cannot run dynamically linked executables intended for generic linux environments out of the box.
      --    For more information, see:\nhttps://nix.dev/permalink/stub-ld"
      vim.lsp.enable({
        'lua_ls',
        'stylua',
      })
    end,
  },
}
