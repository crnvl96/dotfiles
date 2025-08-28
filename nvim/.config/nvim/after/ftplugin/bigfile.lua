local buf = vim.api.nvim_get_current_buf()
vim.schedule(function() vim.bo.syntax = vim.filetype.match({ buf = buf }) or '' end)
