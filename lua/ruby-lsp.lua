--@global: vim

---@class OpenFileCommand
---@field command string
---@field arguments table<table<string>>

---@class RunTestCommand
---@field command string
---@field arguments table<string>
---@alias Command OpenFileCommand | RunTestCommand


---@param command OpenFileCommand
local function open_file(command)
        if not command.arguments or #command.arguments == 0 then
          return
        end
        local uri_table = command.arguments[1]
        if not uri_table or #uri_table == 0 then
          return
        end
        local uri = uri_table[1]
        local filename = vim.uri_to_fname(uri)
        local line = vim.split(uri, "#L")[2]
        -- We need to open the file in a new buffer, but with the same line
        -- number as the original file.
        vim.cmd("edit " .. filename)
        if line then
          vim.cmd("normal! " .. line .. "G")
        end
      end
---@param command RunTestCommand
local function run_test(command)
  local terminal_command = command.arguments[3]
  if not terminal_command then
    return
  end

  local project_root = vim.fn.getcwd()
  local test_command = "cd " .. project_root .. " && " .. vim.fn.shellescape(terminal_command) .. "&& cd -"
  vim.cmd("! " .. test_command)
end

---@param command RunTestCommand
local function run_test_in_terminal(command)
  local terminal_command = command.arguments[3]
  if not terminal_command then
    return
  end

  local project_root = vim.fn.getcwd()
  local test_command = "cd " .. project_root .. " && " .. terminal_command .. "&& cd -"
  local terminal_buffer = vim.fn.bufnr("term://*")

  if terminal_buffer ~= -1 then
    vim.api.nvim_set_current_buf(terminal_buffer)
    vim.fn.feedkeys("a")
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<C-u>", true, true, true))
    vim.fn.feedkeys(test_command)
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true))
  else
    vim.cmd("terminal")
    vim.fn.feedkeys("a")
    vim.fn.feedkeys(test_command)
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<CR>", true, true, true))
  end
end

---@class RubyLspOptions
---@field lspconfig table
---@param options RubyLspOptions?
local function setup(options)
  if not options then
    options = { lspconfig = {} }
  else
    options.lspconfig = options.lspconfig or {}
  end

  -- We need to add eruby to the list of filetypes that the LSP will handle, because currently ruby-lsp lspconfig does not handle it.
  local config_for_lsp = vim.tbl_extend("force", options.lspconfig, {
    filetypes = vim.tbl_extend("force", options.lspconfig.filetypes or {}, { "ruby", "eruby" }),
  })

  ---@param client vim.lsp.Client
  config_for_lsp.on_attach = function(client, _bufnr)
    print("Attaching to ruby_lsp")
    if client.name == "ruby_lsp" then
      vim.lsp.commands["rubyLsp.openFile"] = open_file

      vim.lsp.commands["rubyLsp.runTest"] = run_test

      vim.lsp.commands["rubyLsp.runTestInTerminal"] = run_test_in_terminal
    end
  end

  local lspconfig = require("lspconfig")
  lspconfig.ruby_lsp.setup(config_for_lsp)
end

return { setup = setup }
