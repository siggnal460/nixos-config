local lspconfig = require("lspconfig")

-- Set options
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.mouse = "a" -- allow the mouse to be used in Nvim

-- UI config
vim.opt.relativenumber = true
vim.opt.cursorline = true -- highlight cursor line
vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right
vim.opt.termguicolors = true -- enable 24-bit RGB color in the TUI

-- Searching
vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = false -- do not highlight matches vim.opt.ignorecase = true
vim.opt.smartcase = true -- make case sensitive if uppercase

-- Theme
vim.cmd.colorscheme("tokyonight")

-- Transparency
vim.cmd.highlight({ "Normal", "guibg=none" })
vim.cmd.highlight({ "NonText", "guibg=none" })
vim.cmd.highlight({ "Normal", "ctermbg=none" })
vim.cmd.highlight({ "NonText", "ctermbg=none" })

-- LSPs
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

-- Per language settings
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "*" },
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		if ft == "python" then
			vim.opt.tabstop = 4
			vim.opt.shiftwidth = 4
		elseif ft == "lua" or ft == "nix" then
			vim.opt.tabstop = 2
			vim.opt.shiftwidth = 2
		end
	end,
})
