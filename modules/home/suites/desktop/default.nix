{
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
let
  inherit (lib) mkIf;
  inherit (lib.${namespace}) mkBoolOpt;

  cfg = config.${namespace}.suites.desktop;
in
{
  options.${namespace}.suites.desktop = {
    enable = mkBoolOpt false "Whether or not to enable common desktop applications.";
  };

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      lib.optionals pkgs.stdenv.isLinux [
        appimage-run
        # FIXME: broken nixpkgs
        # bitwarden
        bleachbit
        clac
        dropbox
        dupeguru
        feh
        filelight
        fontpreview
        gparted
        input-leap
        kdePackages.ark
        kdePackages.gwenview
        realvnc-vnc-viewer
        rustdesk-flutter
      ];
  };
}
