---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/luv/library',
          '${3rd}/busted/library',
          '${3rd}/luassert/library',
        },
      },
      completion = {
        callSnippet = 'Replace',
      },
      telemetry = { enabled = false },
    },
  },
}
