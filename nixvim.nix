# nixvim config
{ pkgs, ... }:

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

    local has_words_before = function()
      unpack = unpack or table.unpack
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local snippy = require("snippy")

    local cmp = require("cmp")

    cmp.setup({

      -- ... Your other configuration ...

      mapping = {

        -- ... Your other mappings ...

        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif snippy.can_expand_or_advance() then
            snippy.expand_or_advance()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif snippy.can_jump(-1) then
            snippy.previous()
          else
            fallback()
          end
        end, { "i", "s" }),

        -- ... Your other mappings ...
      },

      -- ... Your other configuration ...
    })
  '';

  keymaps = [
    # nvim tree
    {  
      action = ":NvimTreeToggle<CR>";
      key = "<C-n>";
      mode = "n";
    }
    {  
      action = ":NvimTreeFocus<CR>";
      key = "<C-h>";
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
      action = ":BufferNext<CR>";
      key = "<A-]>";
      mode = "n";
    }

    {
      action = ":BufferPrevious<CR>";
      key = "<A-[>";
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
    gitblame.enable = true;

    cmp = {
      enable = true;
      autoEnableSources = true;
      settings.sources = [
        { name = "snippy"; }
        { name = "nvim_lsp"; }
        { name = "rg"; }
        { name = "treesitter"; }
        { name = "path"; }
        { name = "buffer"; }
      ];
    }; 

    treesitter = {
      enable = true;

      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
    };
  };
}
