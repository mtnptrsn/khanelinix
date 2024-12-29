{
  lib,
  config,
  namespace,
  ...
}:
let
  inherit (lib.${namespace}) enabled;

  cfg = config.${namespace}.user;
in
{
  mtnptrsn = {
    archetypes = {
      personal = enabled;
      workstation = enabled;
    };

    security = {
      sops = {
        enable = true;
        sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
        defaultSopsFile = lib.snowfall.fs.get-file "secrets/khanelimac/default.yaml";
      };
    };

    suites = {
      art = enabled;
      common = enabled;
      desktop = enabled;
      development = enabled;
      games = enabled;
      music = enabled;
      networking = enabled;
      social = enabled;
      video = enabled;
      vm = enabled;
    };

    tools.homebrew.masEnable = true;
  };

  environment.systemPath = [ "/opt/homebrew/bin" ];

  networking = {
    computerName = "Austins MacBook Pro";
    hostName = "khanelimac";
    localHostName = "khanelimac";

    knownNetworkServices = [
      "ThinkPad TBT 3 Dock"
      "Wi-Fi"
      "Thunderbolt Bridge"
    ];
  };

  nix.settings = {
    cores = 16;
    max-jobs = 8;
  };

  security.pam.enableSudoTouchIdAuth = true;

  users.users.${cfg.name} = {
    openssh = {
      authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEpfTVxQKmkAYOrsnroZoTk0LewcBIC4OjlsoJY6QbB0"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7UBwfd7+K0mdkAIb2TE6RzMu6L4wZnG/anuoYqJMPB"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFuMXeT21L3wnxnuzl0rKuE5+8inPSi8ca/Y3ll4s9pC"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKEilFPAgSUwW3N7PTvdTqjaV2MD3cY2oZGKdaS7ndKB"
      ];
    };
  };

  system.stateVersion = 5;
}
