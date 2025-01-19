# nixvim config
{ pkgs, ... }:

{
  enable = true;
  globals.mapleader = " ";

  colorschemes.ayu.enable = true;

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
      key = "<leader>]";
      mode = "n";
    }

    {
      action = ":BufferPrevious<CR>";
      key = "<leader>[";
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
    copilot-lua.enable = true;

    avante = {
      enable = true;
      settings = {
        auto_suggestions_provider = "copilot";
        claude = {
          endpoint = "https://api.anthropic.com";
          max_tokens = 4096;
          model = "claude-3-5-sonnet-20240620";
          temperature = 0;
        };
        behaviour = {
          auto_suggestions = true;
          auto_set_highlight_group = true;
          auto_set_keymaps = true;
          auto_apply_diff_after_generation = false;
          support_paste_from_clipboard = false;
          minimize_diff = true;
        };
        diff = {
          autojump = true;
          debug = false;
          list_opener = "copen";
        };
        highlights = {
          diff = {
            current = "DiffText";
            incoming = "DiffAdd";
          };
        };
        hints = {
          enabled = true;
        };
        mappings = {
          diff = {
            both = "cb";
            next = "]x";
            none = "c0";
            ours = "co";
            prev = "[x";
            theirs = "tc";
          };
        };
        provider = "claude";
        windows = {
          sidebar_header = {
            align = "center";
            rounded = true;
          };
          width = 30;
          wrap = true;
        };
      };
    };

    render-markdown = {
      enable = true;
      settings = {
        file_types = [
          "Avante"
        ];
      };
    };

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
        { name = "copilot_cmp"; }
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

  # init.lua
  extraConfigLua = ''
    vim.o.tabstop = 2
    vim.o.shiftwidth = 2
    vim.o.expandtab = true
    vim.o.softtabstop = 2 
    vim.wo.number = true -- line numbers 

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
      lspconfig[lsp].setup({})
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

    -- -- <<<copilot start>>>
    -- require('copilot').setup({
    --   panel = {
    --     enabled = false,
    --     auto_refresh = false,
    --     keymap = {
    --       jump_prev = "[[",
    --       jump_next = "]]",
    --       accept = "<CR>",
    --       refresh = "gr",
    --       open = "<M-CR>"
    --     },
    --     layout = {
    --       position = "bottom", -- | top | left | right | horizontal | vertical
    --       ratio = 0.4
    --     },
    --   },
    --   suggestion = {
    --     enabled = true,
    --     auto_trigger = true,
    --     hide_during_completion = true,
    --     debounce = 75,
    --     keymap = {
    --       accept = "<M-l>",
    --       accept_word = false,
    --       accept_line = false,
    --       next = "<M-]>",
    --       prev = "<M-[>",
    --       dismiss = "<C-]>",
    --     },
    --   },
    --   filetypes = {
    --     ["*"] = true,
    --   },
    --   copilot_node_command = 'node', -- Node.js version must be > 18.x
    --   server_opts_overrides = {},
    -- })
    -- -- <<<copilot end>>>

    -- -- <<<avante start>>>
    --
    -- -- export appropriate keys if they're used:
    --
    -- -- export ANTHROPIC_API_KEY=your-api-key
    -- -- export OPENAI_API_KEY=your-api-key
    -- -- export AZURE_OPENAI_API_KEY=your-api-key
    --
    -- vim.opt.laststatus = 3
    -- require('avante_lib').load()
    -- require('avante').setup({
    --   ---@alias Provider "claude" | "openai" | "azure" | "gemini" | "cohere" | "copilot" | string
    --   provider = "claude", -- Recommend using Claude
    --   auto_suggestions_provider = "copilot", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
    --   claude = {
    --     endpoint = "https://api.anthropic.com",
    --     model = "claude-3-5-sonnet-20241022",
    --     temperature = 0,
    --     max_tokens = 4096,
    --   },
    --   ---Specify the special dual_boost mode
    --   ---1. enabled: Whether to enable dual_boost mode. Default to false.
    --   ---2. first_provider: The first provider to generate response. Default to "openai".
    --   ---3. second_provider: The second provider to generate response. Default to "claude".
    --   ---4. prompt: The prompt to generate response based on the two reference outputs.
    --   ---5. timeout: Timeout in milliseconds. Default to 60000.
    --   ---How it works:
    --   --- When dual_boost is enabled, avante will generate two responses from the first_provider and second_provider respectively. Then use the response from the first_provider as provider1_output and the response from the second_provider as provider2_output. Finally, avante will generate a response based on the prompt and the two reference outputs, with the default Provider as normal.
    --   ---Note: This is an experimental feature and may not work as expected.
    --   dual_boost = {
    --     enabled = false,
    --     first_provider = "openai",
    --     second_provider = "claude",
    --     prompt = "Based on the two reference outputs below, generate a response that incorporates elements from both but reflects your own judgment and unique perspective. Do not provide any explanation, just give the response directly. Reference Output 1: [{{provider1_output}}], Reference Output 2: [{{provider2_output}}]",
    --     timeout = 60000, -- Timeout in milliseconds
    --   },
    --   behaviour = {
    --     auto_suggestions = true, -- Experimental stage
    --     auto_set_highlight_group = true,
    --     auto_set_keymaps = true,
    --     auto_apply_diff_after_generation = false,
    --     support_paste_from_clipboard = false,
    --     minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
    --   },
    --   mappings = {
    --     --- @class AvanteConflictMappings
    --     diff = {
    --       ours = "co",
    --       theirs = "ct",
    --       all_theirs = "ca",
    --       both = "cb",
    --       cursor = "cc",
    --       next = "]x",
    --       prev = "[x",
    --     },
    --     suggestion = {
    --       accept = "<M-l>",
    --       next = "<M-]>",
    --       prev = "<M-[>",
    --       dismiss = "<C-]>",
    --     },
    --     jump = {
    --       next = "]]",
    --       prev = "[[",
    --     },
    --     submit = {
    --       normal = "<CR>",
    --       insert = "<C-s>",
    --     },
    --     sidebar = {
    --       apply_all = "A",
    --       apply_cursor = "a",
    --       switch_windows = "<Tab>",
    --       reverse_switch_windows = "<S-Tab>",
    --     },
    --   },
    --   hints = { enabled = true },
    --   windows = {
    --     ---@type "right" | "left" | "top" | "bottom"
    --     position = "right", -- the position of the sidebar
    --     wrap = true, -- similar to vim.o.wrap
    --     width = 30, -- default % based on available width
    --     sidebar_header = {
    --       enabled = true, -- true, false to enable/disable the header
    --       align = "center", -- left, center, right for title
    --       rounded = true,
    --     },
    --     input = {
    --       prefix = "> ",
    --       height = 8, -- Height of the input window in vertical layout
    --     },
    --     edit = {
    --       border = "rounded",
    --       start_insert = true, -- Start insert mode when opening the edit window
    --     },
    --     ask = {
    --       floating = false, -- Open the 'AvanteAsk' prompt in a floating window
    --       start_insert = true, -- Start insert mode when opening the ask window
    --       border = "rounded",
    --       ---@type "ours" | "theirs"
    --       focus_on_apply = "ours", -- which diff to focus after applying
    --     },
    --   },
    --   highlights = {
    --     ---@type AvanteConflictHighlights
    --     diff = {
    --       current = "DiffText",
    --       incoming = "DiffAdd",
    --     },
    --   },
    --   --- @class AvanteConflictUserConfig
    --   diff = {
    --     autojump = true,
    --     ---@type string | fun(): any
    --     list_opener = "copen",
    --     --- Override the 'timeoutlen' setting while hovering over a diff (see :help timeoutlen).
    --     --- Helps to avoid entering operator-pending mode with diff mappings starting with `c`.
    --     --- Disable by setting to -1.
    --     override_timeoutlen = 500,
    --   },
    -- })
    -- -- <<<avante end>>>
  '';
}
