# nixos-config

My personal nixos-config. Contains a wide variety of modules for security hardening, gaming, AI,
virtualization, development, etc.

## Structure

```
├── bin
├── images
├── user
|   ├── <user folders>
├── host
|   ├── <host folders>
├── system
|   ├── baseline
|   |   ├── server
|   |   ├── workstation
|   |   ├── console
|   |   ├── htpc
|   ├── extras
|   ├── hardware
|   |   ├── arch
|   |   |   ├── raspi4
|   |   ├── gpu
|   |   |   ├── nvidia
|   |   |   ├── amd
|   |   ├── laptop
|   |   ├── steamdeck
|   ├── shared
```

- **bin**: Contains any custom scripts I've made. These are added to the Nix store and system PATH.
  - nix-switch: Convenience nushell script for updating the system, formatting each file with
    nixfmt, and keeping it in sync with a remote repo.
- **images**: Collection of wallpapers.
- **user**: Per-user configs. Mostly home-manager modules.
- **hosts**: Host-specific modules. For things such as setting hostnames and static IPs. Also
  contains each system's hardware-configuration.nix.
- **system**: System-wide modules.
  - baseline: There are baseline configs for server, workstation, gaming-console and HTPC that can
    get you up-and-running quickly. In each baseline are also submodules pertaining to that baseline
    for more specialized functionality.
  - extras: Additional nix tools I've made.
  - hardware: Modules for certain hardware setups, e.g. graphics card drivers, SteamDeck firmware,
    etc.
  - shared: Modules that have functionality which is shared among other modules.

Note that /etc/nixos and all recursive files should be owned by root:wheel to maximize security and for the auto-update service to work.

## Timer Schedule

| Process                             | Time      |
| ----------------------------------- | --------- |
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

