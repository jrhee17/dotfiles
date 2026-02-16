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

