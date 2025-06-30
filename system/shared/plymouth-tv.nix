{
  boot = {
    kernelParams = [
      "quiet"
      "splash"
      "systemd.show_status=auto"
      "rd.udev.log_level=2"
    ];
    consoleLogLevel = 2;
    initrd.verbose = false;
    loader = {
      timeout = 0;
    };
	  plymouth = {
      enable = true;
		  extraConfig = ''
        ShowDelay=2
        DeviceScale=2
      '';
		};
	};
}
