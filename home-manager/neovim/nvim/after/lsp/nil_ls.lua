---@type vim.lsp.Config
return {
  settings = {
    ['nil'] = {
      formatting = {
        command = { 'allejandra' },
      },
      nix = {
        flake = {
          autoArchive = false,
        },
      },
    },
  },
}
