{ pkgs, ... }:
{
  services.openvpn = {
    restartAfterSleep = true;
    servers = {
      client = {
        autoStart = true;
        updateResolvConf = false;
        config = ''
                    					client
                    					dev tun
                    					remote europe3.vpn.airdns.org 443
                    					resolv-retry infinite
          										pull-filter ignore "dhcp-option DNS"
          										dhcp-option DNS 8.8.8.8
                    					nobind
                    					persist-key
                    					persist-tun
                    					auth-nocache
                    					verb 3
                    					explicit-exit-notify 5
                    					rcvbuf 262144
                    					sndbuf 262144
                    					push-peer-info
                    					setenv UV_IPV6 yes
                    					ca "/root/.vpn/ca.crt"
                    					cert "/root/.vpn/aaron.crt"
                    					key "/root/.vpn/aaron.key"
                    					remote-cert-tls server
                    					comp-lzo no
                    					data-ciphers AES-256-GCM:AES-256-CBC:AES-192-GCM:AES-192-CBC:AES-128-GCM:AES-128-CBC
                    					data-ciphers-fallback AES-256-CBC
                    					proto udp
                    					tls-crypt "/root/.vpn/tls-crypt.key"
                    					auth SHA512
                    				'';
        up = "echo nameserver $nameserver | ${pkgs.openresolv}/sbin/resolvconf -m 0 -a $dev";
        down = "${pkgs.openresolv}/sbin/resolvconf -d $dev";
      };
    };
  };
}
