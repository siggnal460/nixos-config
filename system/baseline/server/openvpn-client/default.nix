{ config, lib, ... }:
{
  systemd.services.rebuild.environment = lib.mkForce {
    NIGHTLY_REFRESH = "reboot-always"; # We want to reset the VPN every night + a download client server does not need to be HA
  };

  services.openvpn = {
    restartAfterSleep = true;
    servers = {
      client = {
        autoStart = true;
        updateResolvConf = true;
        config = ''
					client
	        dev tun
	        resolv-retry infinite
	        nobind
	        persist-key
	        persist-tun
	        verb 3
	        remote-cert-tls server
	        ping 10
	        ping-restart 60
	        sndbuf 524288
	        rcvbuf 524288
	        cipher AES-256-GCM
	        tls-cipher TLS-DHE-RSA-WITH-AES-256-GCM-SHA384
	        proto udp
	        auth-user-pass ${config.sops.secrets."openvpn/mullvad_userpass".path}
	        ca ${config.sops.secrets."openvpn/mullvad_ca".path}
	        script-security 2
	        fast-io
	        remote-random
	        remote 185.65.134.71 1302 # nl-ams-ovpn-001
	        remote 185.65.134.75 1302 # nl-ams-ovpn-005
	        remote 185.65.134.73 1302 # nl-ams-ovpn-003
	        remote 185.65.134.74 1302 # nl-ams-ovpn-004
	        remote 185.65.134.72 1302 # nl-ams-ovpn-002
        '';
      };
    };
  };

  sops.secrets = {
    "openvpn/mullvad_ca".owner = "root";
    "openvpn/mullvad_userpass".owner = "root";
	};
}
