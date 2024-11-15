local plenary_dir = os.getenv("PLENARY_DIR") or "/tmp/plenary.nvim"
local is_not_a_directory = vim.fn.isdirectory(plenary_dir) == 0
if is_not_a_directory then
  vim.fn.system({ "git", "clone", "https://github.com/nvim-lua/plenary.nvim", plenary_dir })
end

local lsp_config_dir = os.getenv("LSP_CONFIG_DIR") or "/tmp/lsp-config.nvim"
is_not_a_directory = vim.fn.isdirectory(lsp_config_dir) == 0
if is_not_a_directory then
  vim.fn.system({ "git", "clone", "https://github.com/neovim/nvim-lspconfig", lsp_config_dir })
end


vim.opt.rtp:append(".")
vim.opt.rtp:append(plenary_dir)
vim.opt.rtp:append(lsp_config_dir)

vim.cmd("runtime plugin/plenary.vim")
vim.cmd("runtime plugin/lspconfig.lua")
require("plenary.busted")
