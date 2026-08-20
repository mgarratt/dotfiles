return {
  {
    "ibhagwan/fzf-lua",
    cmd = "FzfLua",
    keys = {
      { "<Leader>f", "<Cmd>FzfLua files<CR>", desc = "Files" },
      { "<Leader>a", "<Cmd>FzfLua live_grep<CR>", desc = "Grep" },
      { "<Leader>/", "<Cmd>FzfLua blines<CR>", desc = "Buffer lines" },
      { "<Leader>b", "<Cmd>FzfLua buffers<CR>", desc = "Buffers" },
      { "<Leader>:", "<Cmd>FzfLua commands<CR>", desc = "Commands" },
    },
    opts = {},
  },
  {
    "simeji/winresizer",
    keys = { { "<Leader>w", desc = "Resize windows" } },
    init = function() vim.g.winresizer_start_key = "<Leader>w" end,
  },
  { "unblevable/quick-scope", event = "VeryLazy" },
  -- Personal wiki: <Leader>ww index, <Leader>wj journal, <Leader>wp page picker.
  { "lervag/wiki.vim", event = "VeryLazy" },
  {
    "qstrahl/vim-matchmaker",
    event = "VeryLazy",
    init = function() vim.g.matchmaker_enable_startup = 1 end,
  },
  {
    -- Training wheels: nags when you lean on arrows / repeated hjkl.
    "m4xshen/hardtime.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
  },
  -- tmux integration: seamless <C-hjkl> across panes, plus .tmux.conf syntax/focus events.
  { "christoomey/vim-tmux-navigator" },
  { "tmux-plugins/vim-tmux", ft = "tmux" },
  { "tmux-plugins/vim-tmux-focus-events" },
}
