local lspconfig = require('lspconfig')

-- Shared capabilities (for nvim-cmp etc.)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- C/C++ (clangd)
lspconfig.clangd.setup {
  cmd = { "clangd-14" },  -- adjust if needed
  capabilities = capabilities,
}

-- QML (qmlls)
lspconfig.qmlls.setup {
  cmd = { "qmlls" },  -- make sure it's in PATH
  filetypes = { "qml" },
  capabilities = capabilities,
}

-- Lua (neodev)
require('neodev').setup()

-- LSP keymaps & buffer-local commands
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end
    local bufnr = args.buf

    local nmap = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc and ('LSP: ' .. desc) })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
    nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')

    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
  end,
})

-- Autoformat on save (C/C++ & asm only for now)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.qml", "*.c", "*.cpp", "*.h", "*.hpp", "*.asm" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.lsp.set_log_level("off")

