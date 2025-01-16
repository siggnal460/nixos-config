{ lib, ... }:
{
  services = {
    openssh = {
      enable = lib.mkForce true;
      allowSFTP = false;
      settings = {
        X11Forwarding = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        #PasswordAuthentication = false; #need to do some work for this
      };
      openFirewall = true;
      /*
        				extraConfig = ''
        					AllowTcpForwarding yes
        					AllowAgentForwarding no
        					AllowStreamLocalForwarding no
        					AuthenticationMethods publickey
        				'';
      */
    };
    cockpit = {
      enable = true;
      openFirewall = true;
    };
    fail2ban = {
      # monitors ssh logs by default
      enable = true;
      ignoreIP = [ "10.0.0.0/12" ];
    };
  };
}
