return {
  -- NOTE: see `https://github.com/tjdevries/config.nvim/commit/006889bbfb6ff655e2d8e33b26453fa4d614b99b` as well
  {
    'sotte/presenting.nvim',
    opts = {
      options = {
        width = 60,
      },
      separator = {
        markdown = '^<!%-%- presenting%.nvim sep %-%->',
      },
      keep_separator = false,
    },
    cmd = { 'Presenting' },
  },
}
