local lspconfig = require("lspconfig")

-- Set options
vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.mouse = "a" -- allow the mouse to be used in Nvim

-- UI config
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true -- highlight cursor line
vim.opt.splitbelow = true -- open new vertical split bottom
vim.opt.splitright = true -- open new horizontal splits right
vim.opt.termguicolors = true -- enable 24-bit RGB color in the TUI
vim.opt.fillchars:append({ vert = "┃" }) -- thickens the dividing line with panes

-- Searching
vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = false -- do not highlight matches vim.opt.ignorecase = true
vim.opt.smartcase = true -- make case sensitive if uppercase

-- Transparency
vim.cmd.highlight({ "Normal", "guibg=none" })
vim.cmd.highlight({ "NormalNC", "guibg=none" }) -- for split panes
vim.cmd.highlight({ "Normal", "ctermbg=none" })
vim.cmd.highlight({ "NormalNC", "ctermbg=none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

-- TokyoNight
require("tokyonight").setup({
	transparent = true,
	styles = {
		sidebars = "transparent",
		floats = "transparent",
	},
})

-- Theme
vim.cmd.colorscheme("tokyonight")

-- Autocommands
vim.api.nvim_create_autocmd({ "InsertEnter" }, {
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = false
	end,
})

vim.api.nvim_create_autocmd({ "InsertLeave" }, { -- Relative numbers in Normal Mode
	pattern = "*",
	callback = function()
		vim.opt.relativenumber = true
	end,
})

-- lspconfig
lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

lspconfig.pyright.setup({})

lspconfig.nixd.setup({})

lspconfig.nushell.setup({})

-- Treesitter
require("nvim-treesitter.configs").setup {
	highlight = { enable = true };
}

-- Oil
require("oil").setup({
	view_options = { show_hidden = true },
	default_file_explorer = true,
	float = {
		padding = 8,
		max_width = 100,
		max_height = 30,
		border = "single",
		win_options = { winblend = 0 }, --transparency
	},
	keymaps = {
		["<CR>"] = "actions.select",
		["<C-v>"] = "actions.select_vsplit",
		["<C-s>"] = "actions.select_split",
		["-"] = "actions.parent",
		["_"] = "actions.open_cwd",
		["q"] = "actions.close",
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

-- Keymaps
vim.keymap.set("n", "-", function()
	require("oil").open_float() -- opens oil in floating window by default
end, { desc = "Open Oil in floating window" })
