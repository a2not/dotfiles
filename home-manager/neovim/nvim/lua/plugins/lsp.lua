return {
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
          local bufnr = event.buf
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
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

          -- Enable inline completion if supported by the LSP server. Mainly for copilot.
          -- local client = vim.lsp.get_client_by_id(event.data.client_id)
          -- if client ~= nil and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion) then
          --   -- only enable inline completion when cmp menu is not visible
          --   vim.api.nvim_create_autocmd('User', {
          --     pattern = 'BlinkCmpMenuOpen',
          --     callback = function()
          --       vim.lsp.inline_completion.enable(false)
          --     end,
          --   })
          --   vim.api.nvim_create_autocmd('User', {
          --     pattern = 'BlinkCmpMenuClose',
          --     callback = function()
          --       vim.lsp.inline_completion.enable(true)
          --     end,
          --   })
          --
          --   vim.keymap.set('i', '<Tab>', function()
          --     if not vim.lsp.inline_completion.get() then
          --       return '<Tab>'
          --     end
          --   end, {
          --     expr = true,
          --     silent = true,
          --     buffer = bufnr,
          --     desc = 'Confirm inline_completion',
          --   })
          --
          --   vim.keymap.set('i', '<C-n>', function()
          --     vim.lsp.inline_completion.select()
          --   end, { silent = true, buffer = bufnr })
          --   vim.keymap.set('i', '<C-p>', function()
          --     vim.lsp.inline_completion.select({ count = -1 * vim.v.count1 })
          --   end, { silent = true, buffer = bufnr })
          -- end
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
          'zls',
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
