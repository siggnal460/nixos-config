# nixos-config

My personal nixos-config. The flakes are not meant to be used directly without significant tweaks.

## Structure

```
├── ansible
├── bin
├── images
├── user
|   ├── <user folders>
├── host
|   ├── <host folders>
├── secrets
|   ├── <host folders>
├── system
|   ├── baseline
|   |   ├── server
|   |   |   ├── <submodules>
|   |   ├── workstation
|   |   |   ├── <submodules>
|   |   ├── console
|   |   |   ├── <submodules>
|   |   ├── htpc
|   |   |   ├── <submodules>
|   ├── de
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
|   ├── wm
```

- **ansible**: WIP Ansible workflow which will update all machines on update.
- **bin**: Contains any custom scripts I've made. These are added to the Nix store and system PATH.
  - nix-switch: Convenience nushell script for updating the system, formatting each file with nixfmt, and keeping it in sync with a remote repo.
- **images**: Various images such as wallpapers, icons, etc.
- **user**: Per-user configs. Mostly home-manager modules.
- **hosts**: Host-specific modules. For things such as setting hostnames and static IPs. Also contains each system's hardware-configuration.nix.
- **secrets**: Per-host sops-nix yaml secret files.
- **system**: System-wide modules.
  - baseline: There are baseline configs for server, workstation, gaming-console and HTPC. In each baseline are also submodules pertaining to that baseline for more specialized functionality.
  - de: My curated desktop environment setups.
  - extras: Additional nix tools I've made.
  - hardware: Modules for certain hardware setups, e.g. graphics card drivers, SteamDeck firmware, etc.
  - shared: Modules that have functionality which is shared among other modules.
  - wm: My curated window manager setups.

## Timer Schedule

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

## Known Issues

- On COSMIC DE, if the servers are not properly exporting the shares it will case all sorts of odd bugs from Flatpak apps not working to causing the file manager to hang.

