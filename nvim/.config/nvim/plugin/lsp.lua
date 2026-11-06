
-- Shared capabilities (for nvim-cmp etc.)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- C/C++ (clangd)
vim.lsp.config.clangd = {
  cmd = { "clangd-14" },  -- adjust if needed
  capabilities = capabilities,
}

-- QML (qmlls)
vim.lsp.config.qmlls = {
  cmd = { "qmlls" },  -- make sure it's in PATH
  filetypes = { "qml" },
  capabilities = capabilities,
}

vim.lsp.enable({'clangd', 'qmlls'})
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

    nmap('gd', function() vim.lsp.buf.definition() end, '[G]oto [D]efinition')
    nmap('gt', function() vim.lsp.buf.type_definition() end, '[G]oto [T]ype Definition')

    nmap('gr', function()
      vim.lsp.buf.references()
    end, '[G]oto [R]eferences')


    nmap('<leader>D', function()
      vim.lsp.buf.type_definition()
    end, 'Type [D]efinition')

    nmap('<leader>ds', function()
      vim.lsp.buf.document_symbol()
    end, '[D]ocument [S]ymbols')

    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    -- nmap('S', vim.lsp.buf.signature_help, '[S]ignature Help')
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
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
vim.api.nvim_create_autocmd("BufWritePre", {
  group= augroup,
  pattern = { "*.qml", "*.c", "*.cpp", "*.h", "*.hpp", "*.asm" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

vim.lsp.log.set_level("off")

-- Configure diagnostics globally with custom icons
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = '',
      [vim.diagnostic.severity.WARN] = '',
      [vim.diagnostic.severity.INFO] = '',
      [vim.diagnostic.severity.HINT] = '󰌵',
    },
  },
})
