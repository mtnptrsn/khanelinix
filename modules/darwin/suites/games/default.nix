{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.internal; let
  cfg = config.khanelinix.suites.games;
in {
  options.khanelinix.suites.games = with types; {
    enable = mkBoolOpt false "Whether or not to enable games configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
    ];

    homebrew = {
      enable = true;

      global = {
        brewfile = true;
      };

      casks = [
        "moonlight"
      ];

      masApps = {
      };
    };

    khanelinix = {
      apps = {
        # gimp = enabled;
        # inkscape = enabled;
        # blender = enabled;
      };
    };
  };
}
