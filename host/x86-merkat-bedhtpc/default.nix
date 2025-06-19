{
  imports = [
	  ./hardware-configuration.nix
		../../system/shared/plymouth-tv.nix
	];

	zramSwap.enable = true;

  networking = {
    hostName = "x86-merkat-bedhtpc";
  };
}
