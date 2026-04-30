vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/lazy/lazy.nvim")

require("lazy").setup({
  -- completion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },

  -- LSP (Neovim 0.11+ has vim.lsp.config/enable built in)
  { "neovim/nvim-lspconfig" },

  -- telescope (IMPORTANT: include plenary)
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = { "nvim-lua/plenary.nvim" },
  },

  -- nvim-tree
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- autopairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({ check_ts = true })
  
      -- Make `{<CR>` expand to:
      -- {
      --   |
      -- }
      local Rule = require("nvim-autopairs.rule")
      npairs.add_rules({
        Rule("{", "}", "rust"):with_cr(function()
          return true
        end),
      })
    end,
  },
  -- git signs / blame / diff
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      current_line_blame = false,
    },
    keys = {
      {
        "<leader>gb",
        function()
          require("gitsigns").blame()
        end,
        desc = "Git blame buffer",
      },
      {
        "<leader>gdp",
        function()
          require("gitsigns").preview_hunk()
        end,
        desc = "Git diff preview hunk",
      },
      {
        "<leader>gdf",
        function()
          require("gitsigns").diffthis()
        end,
        desc = "Git diff current file",
      },
    },
  },
})

local cmp = require("cmp")

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),

  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
	    checkOnSave = true,
	    check = {
		    command = "clippy",
	    }
    }
  }
})

vim.lsp.enable("rust_analyzer")

-- auto format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format()
  end
})

-- fuzzy search
local builtin = require("telescope.builtin")
-- files / search
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
-- buffers
vim.keymap.set("n", "<leader>fb", builtin.buffers)
-- help tags
vim.keymap.set("n", "<leader>fh", builtin.help_tags)
-- reference
vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions)
vim.keymap.set("n", "<leader>gi", builtin.lsp_implementations)
vim.keymap.set("n", "<leader>gr", builtin.lsp_references)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })

-- diagnostic
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)

-- nvim-tree
require("nvim-tree").setup({
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
  },
})
vim.keymap.set("n", "<leader>fe", ":NvimTreeToggle<CR>")

-- reload on file change
vim.o.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  command = "checktime",
})

-- Show line numbers in the gutter
vim.opt.number = true
vim.opt.relativenumber = true

-- don't intercept mouse
vim.opt.mouse = ""
