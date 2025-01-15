# nixvim config
{
  enable = true;

  globals.mapleader = " ";

  extraConfigLua = ''
    vim.o.tabstop = 2
    vim.o.shiftwidth = 2
    vim.o.expandtab = true
    vim.o.softtabstop = 2 

    local lspconfig = require "lspconfig"

    -- look here for valid servers
    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

    -- load these servers (make sure these are installed locally
    local servers = { 
      "rust_analyzer", 
      "pyright", 
      "nixd" 
    }

    -- lsps with default config
    for _, lsp in ipairs(servers) do
      lspconfig[lsp].setup {}
    end

  '';

  keymaps = [
    # nvim tree
    {  
      action = ":NvimTreeToggle<CR>";
      key = "<C-n>";
      mode = "n";
    }

    # telescope
    {
      action = ":Telescope find_files<CR>";
      key = "<leader>ff";
      mode = "n";
    }
    {
      action = ":Telescope live_grep<CR>";
      key = "<leader>fg";
      mode = "n";
    }
    {
      action = ":Telescope buffers<CR>";
      key = "<leader>fb";
      mode = "n";
    }
    {
      action = ":Telescope help_tags<CR>";
      key = "<leader>fh";
      mode = "n";
    }
  ];

  plugins = {
    web-devicons.enable = true;

    treesitter.enable = true;
    treesitter.settings = {
      highlight.enable = true;
      auto_install = true;
      indent.enable = true;
    };

    nvim-tree.enable = true;
    telescope.enable = true;
    lsp.enable = true;
  };
}
