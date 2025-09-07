return {
  -- "gc" to comment visual selections/lines
  'numToStr/Comment.nvim',
  event = 'VeryLazy',
  config = function()
    require('Comment').setup()
  end,
}
