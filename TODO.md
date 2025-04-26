# To-Do List

## Completely broken
- [ ] Restic backups
- [ ] Komga OIDC
    - This was working, but no more

## Working but not ideal; maybe fixable
- [ ] ComfyUI and InvokeAI do not share a common model folder
    - This is made difficult by the fact that getting ComfyUI to run on NixOS is all kinds of jank anyway and they don't seem to support the same file structure.
    - Maybe one day it will get packaged.

## New features to implement
- [ ] Forgo permissions prompt for Authelia
- [ ] Flesh out Recyclarr config
- [ ] More specialized fail2ban rules
- [ ] Make my zellij config more user-friendly
- [ ] Switch everything to uutils?
- [ ] Retroarch on the second desktop for HTPC
    - Possible to bind a controller button to switch desktops?
- [ ] NFS-Mounted and backed-up home directory
    - [ ] This will fix Ansible script to keep machines in sync

## Waiting on something upstream to happen
- [ ] Two image-generation programs
    - ComfyUI is needed for the backend of OpenWebUI, but it's not as user-friendly.
    - Maybe someday someone will make something more ideal, or OpenWebUI will support InvokeAI.
- [ ] InvokeAI doesn't have support for user accounts.
- [ ] When building with stylix, home-manager fails because some files get automatically created causing collisions
    - Could be because of COSMIC and maybe will get fixed upstream
- [ ] LibreWolf currently doesn't seem to let you set per-profile bookmarks
