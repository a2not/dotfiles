---@type vim.lsp.Config
return {
  -- NOTE: while waiting for https://github.com/nametake/golangci-lint-langserver/issues/51
  init_options = {
    command = {
      'golangci-lint',
      'run',
      '--output.json.path',
      'stdout',
      '--show-stats=false',
      '--issues-exit-code=1',
    },
  },
}
