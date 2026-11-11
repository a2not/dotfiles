---@type vim.lsp.Config
return {
  settings = {
    workingDirectory = { mode = 'auto' },
  },
  on_attach = function(_, buffer_number)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = buffer_number,
      command = 'EslintFixAll',
    })
  end,
}
