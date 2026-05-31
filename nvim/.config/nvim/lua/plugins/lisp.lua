return {
  { "Olical/conjure", ft = { "clojure", "fennel" } },
  {
    "eraserhd/parinfer-rust",
    build = "cargo build --release",
    ft = { "clojure", "fennel", "scheme", "lisp" },
  },
  {
    "clojure-vim/vim-jack-in",
    ft = "clojure",
    dependencies = { "tpope/vim-dispatch", "radenling/vim-dispatch-neovim" },
  },
}
