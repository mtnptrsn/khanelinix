{ config
, lib
, ...
}: {
  programs.nixvim = {
    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    keymaps =
      let
        normal =
          lib.mapAttrsToList
            (key: { action, options }: {
              mode = "n";
              inherit action key options;
            })
            {
              "<Space>" = { action = "<NOP>"; options = { }; };

              # Esc to clear search results
              "<esc>" = { action = ":noh<CR>"; options = { }; };

              # fix Y behaviour
              "Y" = { action = "y$"; options = { }; };

              # back and fourth between the two most recent files
              "<C-c>" = { action = ":b#<CR>"; options = { }; };

              # close buffer
              "<leader>c" = { action = ":BufferClose<CR>"; options = { desc = "Close buffer"; }; };
              # Buffer mappings
              # "<leader>b" = { action = ""; options = { desc = "Buffer"; }; };
              "<leader>bc" = { action = ":BufferCloseAllButCurrent<CR>"; options = { desc = "Close all buffers but current"; }; }; # requires barbar
              "<leader>bC" = { action = ":bufdo bdelete<CR>"; options = { desc = "Close all buffers"; }; };
              "<leader>b]" = { action = ":BufferNext<CR>"; options = { desc = "Next buffer"; }; };
              "<leader>b[" = { action = ":BufferPrevious<CR>"; options = { desc = "Previous buffer"; }; };
              "<leader>bp" = { action = ":BufferPin<CR>"; options = { desc = "Pin buffer"; }; };

              # navigate to left/right window
              "<leader>[" = { action = "<C-w>h"; options = { desc = "Left window"; }; };
              "<leader>]" = { action = "<C-w>l"; options = { desc = "Right window"; }; };

              # resize with arrows
              "<C-Up>" = { action = ":resize -2<CR>"; options = { }; };
              "<C-Down>" = { action = ":resize +2<CR>"; options = { }; };
              "<C-Left>" = { action = ":vertical resize +2<CR>"; options = { }; };
              "<C-Right>" = { action = ":vertical resize -2<CR>"; options = { }; };

              # move current line up/down
              # M = Alt key
              "<M-k>" = { action = ":move-2<CR>"; options = { }; };
              "<M-j>" = { action = ":move+<CR>"; options = { }; };

              "<Leader>w" = {
                action = "<Cmd>w<CR>"; # Action to perform (save the file in this case)
                options = {
                  desc = "Save";
                };
              };

              "j" = { action = "v:count == 0 ? 'gj' : 'j'"; options = { desc = "Move cursor down"; expr = true; }; };
              "k" = { action = "v:count == 0 ? 'gk' : 'k'"; options = { desc = "Move cursor up"; expr = true; }; };
              "<Leader>q" = { action = "<Cmd>confirm q<CR>"; options = { desc = "Quit"; }; };
              "<Leader>n" = { action = "<Cmd>enew<CR>"; options = { desc = "New File"; }; };
              "<leader>W" = { action = "<Cmd>w!<CR>"; options = { desc = "Force write"; }; };
              "<leader>Q" = { action = "<Cmd>q!<CR>"; options = { desc = "Force quit"; }; };
              "|" = { action = "<Cmd>vsplit<CR>"; options = { desc = "Vertical Split"; }; };
              "\\" = { action = "<Cmd>split<CR>"; options = { desc = "Horizontal Split"; }; };
            };
        visual =
          lib.mapAttrsToList
            (key: { action, options }: {
              mode = "v";
              inherit action key options;
            })
            {
              # Better indenting
              "<S-Tab>" = { action = "<gv"; options = { desc = "Unindent line"; }; };
              "<" = { action = "<gv"; options = { desc = "Unindent line"; }; };
              "<Tab>" = { action = ">gv"; options = { desc = "Indent line"; }; };
              ">" = { action = ">gv"; options = { desc = "Indent line"; }; };

              # Move selected line/block in visual mode
              "K" = { action = ":m '<-2<CR>gv=gv"; options = { }; };
              "J" = { action = ":m '>+1<CR>gv=gv"; options = { }; };
            };
      in
      config.nixvim.helpers.keymaps.mkKeymaps
        { options.silent = true; }
        (normal ++ visual);
  };
}
