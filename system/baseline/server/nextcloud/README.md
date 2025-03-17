# Nextcloud

## Venting

I tried various nextcloud setups and eventually settled on linuxserver.io containers. The nixpkgs
version uses nginx, and I would need to get another Let's Encrypt cert which is overkill since I use
caddy on a dedicated reverse proxy. I don't think it would work anyway, since I'm using Authelia and
Let's Encrypt get's rerouted to that when you try and make the cert. You can use caddy instead of
nginx, but it doesn't seem like anything is built out to do that remotely through network. Https is
required by the user_oidc plugin unfortunately.

There is also an oidc_login plugin, which I was nearly successful in implementing but it ultimately
produced a very cryptic error before it could get Authelia to successfully reroute back to
Nextcloud. Using that plugin with the container is also quite hard to do declaritively since
Nextcloud does not like it's config.php being read-only. There is an option for it, but it seemingly
doesn't work. That plugin doesn't seem to be actively maintained anymore anyway.

Also I wanted nextcloud and it's database on it's own network seperate from the media containers,
but this breaks outside internet access for some reason so they are just in the default "podman"
network.

## Installation

There are a few imperitive steps. You need to connect to the mariadb container which can be accessed
at "nextcloud-mariadb:3306". Then you need to install the user_oidc plugin and follow the
[Authelia guide](https://www.authelia.com/integration/openid-connect/nextcloud/). Passwords and
secrets are in the sops file.
