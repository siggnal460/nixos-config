# AI Module
Much AI-related software has not yet been packaged in nixpkgs, so instead I opt to use OCI containers with a
podman backend. There are two sets of services for each GPU that I have.

This setup is a bit touchy, however. If nix decides to not run systemd-tmpfiles-resetup on a config switch,
(not sure why it does sometimes but not others) the folders will not be made in time when the container
wants to use them. Usually this isn't a problem but there are occasions where you will get weird errors complaining
that a file isn't located in the expected spot even though it is clearly there. So you may need to manually
ensure each folder is made prior to running the switch so the container has something to use.
