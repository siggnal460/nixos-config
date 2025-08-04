# HTPC

This home theatre PC builds opens up a Sway session with Kodi on Workspace 1 and a LibreWolf kiosk profile with YouTube (with UBlock, SponsorBlock, and Clickbait Remover) on Workspace 2. I was originally using Cage for this but that project seems very reluctant to implement new Wayland protocols which would be useful for an HTPC build.

## Features

- Workspaces can be moved with CTRL-<number> (easier then Meta-<number> on my little keyboard remote).
- Font, cursor and UI scaling have been increased.
- All Sway UI elements are disabled.
- 20 minutes of idle will put the device into sleep.
- Blue light filter gradually sets in between 1900 and 2030.

## Todo

1. [ ] Add RetroArch in Workspace 3 or implement declaritively into Kodi
2. [ ] Declare Add-On settings in Nix config
3. [ ] Get Invidious to work
4. [ ] Figure out how to turn the connected TV to turn off remotely (much harder than you would think)
5. [ ] Possible to Wake-on-Lan so the device can get it's updates at night?
6. [ ] Pimp out lock screen
7. [ ] Wait for Sway to support HDR.
