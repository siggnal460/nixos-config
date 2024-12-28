{
  boot = {
    kernelParams = [
      "quiet"
      "splash"
      "rd.systemd.show_status=false"
      "udev.log_level=0"
      "udev.log_priority=3"
      "boot.shell_on_fail"
    ];
    initrd.verbose = false;
    plymouth = {
      enable = true;
    };
  };
}
