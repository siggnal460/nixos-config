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

## Timer Schedule

| Process                     | Time          |
| --------------------------- | ------------- |
| Nix Store Optimization      | 0000          |
| nh Garbage Collection       | 0015 Mondays  |
| Podman Garbage Collection   | 0015 Tuesdays |
| Restic Backups              | 0030-0130     |
| Podman Auto-Upgrade         | 0030-0330     |
| ClamAV Scanning             | 0145          |
| update-flake-lock GH Action | 0330          |
| Nix Auto-Upgrade + Reboot   | 0400-0500     |
