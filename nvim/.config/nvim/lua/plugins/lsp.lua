return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Editor-only servers (mason package names). CLI tools (ruff/prettier/shellcheck)
      -- come from mise instead — see lua/plugins/format-lint.lua. mason-tool-installer
      -- is the declarative install list and emits MasonToolsUpdateCompleted, which the
      -- bootstrap relies on to provision servers headlessly.
      require("mason-tool-installer").setup({
        ensure_installed = {
          "lua-language-server", "pyright", "ruby-lsp",
          "typescript-language-server", "terraform-ls",
        },
        run_on_start = true,
      })

      -- mason-lspconfig enables any installed-and-mapped server via vim.lsp.enable.
      require("mason-lspconfig").setup({ automatic_enable = true })

      -- Completion capabilities applied to every server.
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      -- lua_ls edits this very config, so teach it the `vim` global.
      vim.lsp.config("lua_ls", {
        settings = { Lua = { diagnostics = { globals = { "vim" } } } },
      })

      -- Buffer-local keymaps once a server attaches. Replaces the old ctags/tagbar flow.
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local fzf = require("fzf-lua")
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = args.buf, desc = desc })
          end
          map("gd", fzf.lsp_definitions, "Definition")
          map("gr", fzf.lsp_references, "References")
          map("K", vim.lsp.buf.hover, "Hover")
          map("<Leader>rn", vim.lsp.buf.rename, "Rename")
          map("<Leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<Leader>t", fzf.lsp_document_symbols, "Document symbols")
          map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")
          map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
        end,
      })
    end,
  },
}
