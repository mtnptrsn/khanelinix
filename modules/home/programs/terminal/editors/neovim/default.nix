{
  config,
  lib,
  namespace,
  system,
  inputs,
  pkgs,
  osConfig,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;
  inherit (lib.${namespace}) mkBoolOpt;
  inherit (inputs) khanelivim;

  cfg = config.${namespace}.programs.terminal.editors.neovim;
in
{
  options.${namespace}.programs.terminal.editors.neovim = {
    enable = mkEnableOption "neovim";
    default = mkBoolOpt true "Whether to set Neovim as the session EDITOR";
  };

  config = mkIf cfg.enable {
    home = {
      # file = mkIf pkgs.stdenv.isDarwin { "Library/Preferences/glow/glow.yml".text = config; };

      sessionVariables = {
        EDITOR = mkIf cfg.default "nvim";
      };
      packages = [
        (khanelivim.packages.${system}.default.extend {
          plugins.lsp.servers.nixd.settings =
            let
              flake = ''(builtins.getFlake "${inputs.self}")'';
            in
            {
              options = rec {
                nix-darwin.expr = ''${flake}.darwinConfigurations.khanelimac.options'';
                nixos.expr = ''${flake}.nixosConfigurations.mtnptrsn.options'';
                home-manager.expr = ''${nixos.expr}.home-manager.users.type.getSubOptions [ ]'';
              };
            };
        })
        pkgs.nvrh
      ];
    };

    sops.secrets = lib.mkIf osConfig.${namespace}.security.sops.enable {
      wakatime = {
        sopsFile = lib.snowfall.fs.get-file "secrets/khaneliman/default.yaml";
        path = "${config.home.homeDirectory}/.wakatime.cfg";
      };
    };

    # xdg.configFile = mkIf pkgs.stdenv.isLinux { "glow/glow.yml".text = config; };
  };
}
