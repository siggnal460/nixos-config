{
  pkgs,
  config,
  lib,
  ...
}:
let
  nl-ams-ovpn-001 = "185.65.134.71";
  nl-ams-ovpn-002 = "185.65.134.72";
  nl-ams-ovpn-003 = "185.65.134.73";
  nl-ams-ovpn-004 = "185.65.134.74";
  nl-ams-ovpn-005 = "185.65.134.75";
in
{
  systemd.services.rebuild.environment = lib.mkForce {
    NIGHTLY_REFRESH = "reboot-always"; # We want to reset the VPN every night anyway
  };

  networking.firewall = {
    ## these IPtables rules will only allow NFS, ssh port 22, deluge, loopback, broadcast and VPN connections
    extraCommands = ''
      			${pkgs.iptables}/bin/iptables -P OUTPUT DROP
      			${pkgs.iptables}/bin/iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 22 -j ACCEPT
      			${pkgs.iptables}/bin/iptables -A INPUT -p tcp -s 192.168.1.0/24 --dport 8112 -j ACCEPT
      			${pkgs.iptables}/bin/iptables -A INPUT -s x86-rakmnt-mediaserver/32 -p tcp --sport 2049 -j ACCEPT
      			${pkgs.iptables}/bin/iptables -A OUTPUT -d x86-rakmnt-mediaserver/32 -p tcp --dport 2049 -j ACCEPT
      			${pkgs.iptables}/bin/iptables -A OUTPUT -o tun+ -j ACCEPT
      			${pkgs.iptables}/bin/iptables -A INPUT -i lo -j ACCEPT
      			${pkgs.iptables}/bin/iptables -A OUTPUT -o lo -j ACCEPT
      			${pkgs.iptables}/bin/iptables -A OUTPUT -d 255.255.255.255 -j ACCEPT
      			${pkgs.iptables}/bin/iptables -A INPUT -s 255.255.255.255 -j ACCEPT
      			${pkgs.iptables}/bin/iptables -A OUTPUT -o end+ -p udp -m multiport --dports 53,1300:1302,1194:1197 -d ${nl-ams-ovpn-001}/24,${nl-ams-ovpn-002}/24,${nl-ams-ovpn-003}/24,${nl-ams-ovpn-004}/24,${nl-ams-ovpn-005}/24 -j ACCEPT
      			${pkgs.iptables}/bin/iptables -A OUTPUT -o end+ -p tcp -m multiport --dports 53,443 -d ${nl-ams-ovpn-001}/24,${nl-ams-ovpn-002}/24,${nl-ams-ovpn-003}/24,${nl-ams-ovpn-004}/24,${nl-ams-ovpn-005}/24 -j ACCEPT
      		'';
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
          remote ${nl-ams-ovpn-001} 1302
          remote ${nl-ams-ovpn-002} 1302
          remote ${nl-ams-ovpn-003} 1302
          remote ${nl-ams-ovpn-004} 1302
          remote ${nl-ams-ovpn-005} 1302
        '';
      };
    };
  };

  sops.secrets = {
    "openvpn/mullvad_ca".owner = "root";
    "openvpn/mullvad_userpass".owner = "root";
  };
}
