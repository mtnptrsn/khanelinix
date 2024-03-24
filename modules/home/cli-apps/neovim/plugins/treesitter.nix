{ config, ... }: {
  programs.nixvim.plugins = {
    treesitter = {
      enable = true;

      nixvimInjections = true;

      folding = true;
      indent = true;

      grammarPackages = with config.programs.nixvim.plugins.treesitter.package.builtGrammars; [
        bash
        bicep
        c
        html
        javascript
        latex
        lua
        nix
        norg
        python
        rust
        vimdoc
      ];
    };

    treesitter-refactor = {
      enable = true;

      highlightDefinitions = {
        enable = true;
        clearOnCursorMove = true;
      };
      smartRename = {
        enable = true;
      };
      navigation = {
        enable = true;
      };
    };
  };
}
