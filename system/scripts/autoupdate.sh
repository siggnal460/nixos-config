echo "Beginning rebuild service."

POWER_CYCLE_START_HOUR=4
POWER_CYCLE_END_HOUR=5

cpus=$(nproc)
build_cores=$(((cpus + 3) / 4))
ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ram_mb=$(expr $ram_kb / 1024)
ram_gb=$(expr $ram_mb / 1024)
build_jobs=$(((ram_gb + 3) / 4))

in_power_cycle_window() {
    hour=$(date +%H)
    [ "$hour" -ge "$POWER_CYCLE_START_HOUR" ] && [ "$hour" -lt "$POWER_CYCLE_END_HOUR" ]
}

window_message="power cycle window of ${POWER_CYCLE_START_HOUR}00-${POWER_CYCLE_END_HOUR}00"

# Pops a desktop notification in NOTIFY_USER's session. No-ops quietly if
# that user has no active session (headless server, or the PC is off).
notify_user() {
    [ -n "$NOTIFY_USER" ] || return 0
    uid=$(id -u "$NOTIFY_USER" 2> /dev/null) || return 0
    [ -S "/run/user/${uid}/bus" ] || return 0
    /run/wrappers/bin/sudo -u "$NOTIFY_USER" \
        XDG_RUNTIME_DIR="/run/user/${uid}" \
        DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/${uid}/bus" \
        notify-send "$@" || true
}

echo "Rebuild Information - Hostname: $HOSTNAME ; NIGHTLY_REFRESH: $NIGHTLY_REFRESH ; Current Hour: $(date +%H)"
notify_user "NixOS Autoupdate" "Starting update on $HOSTNAME..."

echo "Running \"nixos-rebuild boot\"..."
nixos-rebuild boot --cores $build_cores -j $build_jobs --accept-flake-config
booted="$(readlink /run/booted-system/{initrd,kernel,kernel-modules})"
built="$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

if [ "$NIGHTLY_REFRESH" = "poweroff-always" ]; then
    echo "Running \"nixos-rebuild switch\"..."
    nixos-rebuild switch --cores $build_cores -j $build_jobs --accept-flake-config
    if in_power_cycle_window; then
        echo "Within poweroff window. Goodbye!"
        notify_user "NixOS Autoupdate" "Update applied on $HOSTNAME. Shutting down."
        sleep 20s
        poweroff
    else
        echo "Not within $window_message, skipping poweroff."
        notify_user "NixOS Autoupdate" "Update applied on $HOSTNAME."
    fi

elif [ "$NIGHTLY_REFRESH" = "reboot-always" ]; then
    echo "Running \"nixos-rebuild switch\"..."
    nixos-rebuild switch --cores $build_cores -j $build_jobs --accept-flake-config
    if in_power_cycle_window; then
        echo "Machine set to always reboot and it is within the power cycle window. Rebooting now."
        notify_user "NixOS Autoupdate" "Update applied on $HOSTNAME. Rebooting."
        sleep 20s
        reboot now
    else
        echo "Not within $window_message, skipping reboot."
        notify_user "NixOS Autoupdate" "Update applied on $HOSTNAME."
    fi

elif [ "$NIGHTLY_REFRESH" = "reboot-if-needed" ]; then
    if [ "${booted}" = "${built}" ]; then
        echo "Reboot not necessary."
        echo "Running \"nixos-rebuild switch\"..."
        nixos-rebuild switch --cores $build_cores -j $build_jobs --accept-flake-config
        notify_user "NixOS Autoupdate" "Update applied on $HOSTNAME."
    elif in_power_cycle_window; then
        echo "Reboot necessary and within reboot window. Rebooting now."
        notify_user "NixOS Autoupdate" "Update staged on $HOSTNAME. Rebooting now."
        sleep 20s
        reboot now
    else
        echo "Refresh is necessary, but it was not within the $window_message so it was skipped."
        notify_user "NixOS Autoupdate" "Update staged on $HOSTNAME, waiting for the next reboot window."
    fi

else
    echo 'Environmental variable NIGHTLY_REFRESH was not set to an appropriate value ("poweroff-always", "reboot-always" or "reboot-if-needed"). Action will not be taken.'
    notify_user "NixOS Autoupdate" "Update on $HOSTNAME did not run: NIGHTLY_REFRESH is misconfigured."

fi
