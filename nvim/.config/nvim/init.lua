-- Leader keys must be set before lazy loads any plugin.
vim.g.mapleader = "\\"
vim.g.maplocalleader = ","

-- No remote-host providers are needed (every plugin is lua/vimscript). Disabling them
-- keeps :checkhealth quiet, trims startup, and drops the old pynvim dependency.
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- Syntax-based clojure folding/alignment (used by the builtin ftplugin alongside conjure).
vim.g.clojure_fold = 1
vim.g.clojure_align_multiline_strings = 1

local opt = vim.opt
opt.modeline = true
opt.modelines = 5
opt.number = true
opt.relativenumber = true
opt.background = "dark"
opt.ignorecase = true
opt.smartcase = true
opt.autoindent = true
opt.expandtab = true
opt.tabstop = 4
opt.shiftwidth = 0          -- follow tabstop for indent width
opt.splitbelow = true
opt.splitright = true
opt.switchbuf = "usetab"    -- reuse an open window/tab when switching buffers
opt.ttimeoutlen = 10
opt.signcolumn = "yes"
opt.list = true
opt.listchars = { tab = ">-", trail = "·", extends = ">" }
opt.matchpairs:append("<:>")
opt.wildmode = { "list:longest", "full" }
opt.completeopt = { "menuone", "noselect" }   -- let nvim-cmp drive the menu
opt.diffopt:append({ "algorithm:patience", "indent-heuristic" })
opt.colorcolumn = "80,120"

-- Treesitter-driven folding, but never fold on open.
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldenable = false
opt.foldlevelstart = 99

-- YAML is conventionally two-space.
vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml",
  callback = function()
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
})

-- Leave terminal mode.
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]])
-- Close the current buffer but keep the window.
vim.keymap.set("n", "<Leader>q", "<Cmd>bp<Bar>sp<Bar>bn<Bar>bd<CR>", { silent = true })
-- Save.
vim.keymap.set("n", "<Leader>s", "<Cmd>w<CR>", { silent = true })

-- Bootstrap lazy.nvim, then load every spec under lua/plugins/.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  change_detection = { notify = false },
})
