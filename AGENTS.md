# Overview

This is my NixOS configuration repo for my workstations and homelab

# Hosts

Each host has a flake.

- x86-atxtwr-gamingpc: My main gaming PC, configuration optimized for personal computing
- x86-merkat-auth: Auth server, runs Authelia and LLDAP
- x86-merkat-entry: Entrypoint into service, contains reverse proxy and homepage
- x86-rakmnt-mediaserver: My fileserver hosting most services
- x86-minitx-jovian: A SteamOS-like gaming console attached to a TV
- x86-stmdck-jovian: Handheld gaming PC

# Timer Schedule

| Process                             | Time      |
| ----------------------------------- | --------- |
| Podman auto-upgrade (default)       | 1045      |
| Podman auto-upgrade (computeserver) | 0000      |
| restic backup (Jellyfin)            | 0010      |
| nix store optimization              | 0030      |
| nh garbage collection               | 0045 Mon  |
| Podman garbage collection           | 0045 Tue  |
| ClamAV scanning                     | 0100      |
| Podman auto-upgrade (mediaserver)   | 0115      |
| Podman auto-upgrade (downloadclient)| 0230      |
| update-flake-lock GH Action         | 0330      |
| NixOS auto-upgrade window           | 0400-0430 |
| poweroff/reboot window              | 0400-0500 |

I purposefully spread out podman auto-upgrades between hosts because otherwise I will run into hourly ratelimits
