return {
  {
    'sainnhe/gruvbox-material',
    enabled = false,
    config = function()
      vim.cmd.colorscheme('gruvbox-material')
      vim.g.gruvbox_material_transparent_background = 1
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('tokyonight').setup({
        style = 'night',
        transparent = true,
        styles = {
          sidebars = 'transparent',
          floats = 'transparent',
        },
      })
      vim.cmd.colorscheme('tokyonight')
    end,
  },
}
