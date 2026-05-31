return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",   -- stable API; `main` is the unfinished rewrite (no configs module)
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "lua", "vim", "vimdoc", "bash", "python", "ruby",
        "javascript", "typescript", "tsx", "json", "yaml",
        "terraform", "hcl", "clojure", "markdown", "markdown_inline",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },
}
