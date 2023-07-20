{lib, ...}:
with lib.internal; {
  khanelinix = {
    suites = {
      art = enabled;
      brew = enabled;
      business = enabled;
      common = enabled;
      desktop = enabled;
      development = enabled;
      games = enabled;
      music = enabled;
      social = enabled;
      video = enabled;
      vm = enabled;
    };
  };

  environment.systemPath = [
    "/opt/homebrew/bin"
  ];

  system.stateVersion = 4;
}
