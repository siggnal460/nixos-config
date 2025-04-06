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
        PasswordAuthentication = false;
      };
      openFirewall = true;
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
