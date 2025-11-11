{
  pkgs,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {

  owner = "christiaangoossens";
  domain = "auth_oidc";
  version = "v0.6.3-alpha";

  src = fetchFromGitHub {
    owner = "christiaangoossens";
    repo = "hass-oidc-auth";
    rev = "v${version}";
    sha256 = "sha256-+R2IIs9MixR8epVpk4QycN8PjOfRITlZ+oUbdPEk2eA=";
  };

  propagatedBuildInputs = [
    pkgs.python313Packages.aiofiles
    pkgs.python313Packages.jinja2
    pkgs.python313Packages.bcrypt
    pkgs.python313Packages.joserfc
    pkgs.python313Packages.python-jose
  ];
}
