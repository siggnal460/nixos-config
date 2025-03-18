# To-Do List

## Completely broken
- [ ] Linkwarden (maybe replace with something else?)
- [ ] Recyclarr
    - Doesn't seem to be any errors but it doesn't actually do anything.
- [ ] Komga OIDC
- [ ] OpenWebUI OIDC
    - This was working, but no more
- [ ] NixOS Auto-Upgrade doesn't appear to update the lock file or perhaps function at all

## Working but not ideal; maybe fixable
- [ ] ComfyUI and InvokeAI do not share a common model file
    - This is made difficult by the fact that getting ComfyUI to run on NixOS is all kinds of jank anyway and they don't seem to support the same file structure.
    - Maybe one day it will get packaged.

## New features to implement
- [ ] More specialized fail2ban rules
- [ ] Make my zellij config more user-friendly
- [ ] Switch everything to uutils?

## Waiting on something upstream to happen
- [ ] Two image-generation programs
    - ComfyUI is needed for the backend of OpenWebUI, but it's not as friendly.
    - Maybe someday someone will make something more ideal, or OpenWebUI will support InvokeAI.
- [ ] InvokeAI doesn't have support for user accounts.
- [ ] When building with stylix, home-manager fails because some files get automatically created causing collisions
    - Could be because of COSMIC and maybe will get fixed upstream
