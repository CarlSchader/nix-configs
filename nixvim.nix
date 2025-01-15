# nixvim config

{
  enable = true;

  keymaps = [
    {
      action = ":NvimTreeTogagle<CR>";
      key = "<C-n>";
      mode = "n";
    }
  ];

  plugins = {
    treesitter = {
      enable = true;
    };

    nvim-tree = {
      enable = true;
    };
  };
}
