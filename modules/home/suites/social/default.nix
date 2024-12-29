{
  config,
  lib,
  namespace,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt enabled;

  cfg = config.${namespace}.suites.social;
in
{
  options.${namespace}.suites.social = {
    enable = mkBoolOpt false "Whether or not to enable social configuration.";
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        caprine-bin
        element-desktop
        telegram-desktop
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        # TODO: migrate to darwin after version bump
        slack
      ];

    mtnptrsn = {
      programs = {
        graphical.apps = {
          discord = lib.mkDefault enabled;
          caprine = lib.mkDefault enabled;
        };

        terminal.social = {
          slack-term = lib.mkDefault enabled;
          twitch-tui = lib.mkDefault enabled;
        };
      };
    };
  };
}
