return  {
  {
    'nvim-telescope/telescope.nvim', 
    tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local builtin = require("telescope.builtin")  -- load telescope module into lua scope
      vim.keymap.set('n', '<C-p>', builtin.find_files, {}) -- keymap for the builtin telescope moduel  end
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})                                      
    end
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    -- This is your opts table
    config = function()
      require("telescope").setup({
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown {
            }
          }
        }
      })
      require("telescope").load_extension("ui-select")
    end
  },
}
