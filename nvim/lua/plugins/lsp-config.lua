return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
            "lua_ls",
            "pyright",
            "ruff_lsp"}
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require('lspconfig')
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Common on_attach function for shared keybindings and settings
      local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }

        -- Key mappings
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format({ async = true })
        end, opts)
      end

      -- Function to check if a command exists
      local function command_exists(command)
        local handle = io.popen('command -v ' .. command)
        if handle then
          local result = handle:read('*a')
          handle:close()
          return result and result:len() > 0
        end
        return false
      end

      -- Lua LSP setup
      lspconfig.lua_ls.setup({
        capabilities = capabilities,  -- The completion capabilities we discussed earlier
        on_attach = on_attach,       -- Function called when LSP attaches to a buffer
      })
      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic",
              diagnosticSeverityOverrides = {
                reportGeneralTypeIssues = "warning",
                reportOptionalMemberAccess = "warning",
                reportOptionalCall = "warning",
                reportOptionalIterable = "warning",
                reportOptionalContextManager = "warning",
                reportOptionalOperand = "warning",
              },
            }
          }
        }
      })

      -- Setup Ruff LSP if the command exists (installed globally)
      if command_exists('ruff-lsp') then
        -- Ruff LSP setup
        lspconfig.ruff_lsp.setup({
          capabilities = capabilities,
          on_attach = on_attach,
          init_options = {
            settings = {
              args = {}
            }
          }
        })
      end

      -- Configure diagnostics appearance
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover, {
          border = "rounded",
        }
      )
      -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
      -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
      -- vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, {})
    end
  }
}
