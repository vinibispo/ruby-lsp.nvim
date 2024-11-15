# ruby-lsp.nvim

# Enhance your Ruby LSP experience with this plugin.

## Features

- [X] Open File
- [X] Run Test
- [X] Run Test in Terminal
- [ ] Debug Test

## Prerequisites
- Ruby
- Ruby LSP
- Lspconfig
- Neovim >= 0.8

## Installation

- [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "vinibispo/ruby-lsp.nvim", requires = { "neovim/nvim-lspconfig" }, config = function()
        local ruby_lsp = require("ruby-lsp")

        -- on LspAttach or on_attach setup this
        ruby_lsp.setup()
        -- Example:
        local lspconfig = require("lspconfig")
        lspconfig.ruby_lsp.setup({
            on_attach = function(client, bufnr)
                -- other on_attach code
                ruby_lsp.setup()
            end
        })
    end
}
```
    
