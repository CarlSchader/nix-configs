# nixvim config
{
  enable = true;

  colorschemes.ayu.enable = true;

  globals.mapleader = " ";

  extraConfigLua = ''
    vim.o.tabstop = 2
    vim.o.shiftwidth = 2
    vim.o.expandtab = true
    vim.o.softtabstop = 2 

    local lspconfig = require "lspconfig"

    -- https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md    
    -- load these servers (make sure these are installed locally
    -- :help lspconfig-all

    local servers = { 
      "rust_analyzer", 
      "pyright", 
      "nixd",
      "ts_ls"
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

    # barbar
    {
      action = ":BufferPrevious<CR>";
      key = "<S-Tab>";
      mode = "n";
    }
    {
      action = ":BufferNext<CR>";
      key = "<Tab>";
      mode = "n";
    }
    {
      action = ":BufferClose<CR>";
      key = "<leader>x";
      mode = "n";
    }
  ];

  plugins = {
    lsp.enable = true;
    nvim-tree.enable = true;
    telescope.enable = true;
    web-devicons.enable = true;
    barbar.enable = true;

    treesitter = {
      enable = true;

      settings = {
        highlight.enable = true;
        indent.enable = true;

        # auto_install = false;
        # ensure_installed = [
        #   "nix"
        #   "python"
        #   "rust"
        #   "javascript"
        #   "rust"
        # ];
      };
    };
  };
}
