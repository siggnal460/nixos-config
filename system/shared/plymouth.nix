{
  boot = {
    kernelParams = [
      "quiet"
      "splash"
      "systemd.show_status=auto"
      "rd.udev.log_level=2"
    ];
    consoleLogLevel = 3;
    initrd.verbose = false;
    plymouth = {
      enable = true;
    };
  };
}
