echo "Beginning rebuild service."
current_hour=$(date +%H)
cpus=$(nproc)
build_cores=$(((cpus + 3) / 4))
ram_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
ram_mb=$(expr $ram_kb / 1024)
ram_gb=$(expr $ram_mb / 1024)
build_mem=$(((ram_gb + 3) / 4))

if [ "$current_hour" -ge 3 ] && [ "$current_hour" -lt 5 ]; then
    echo "Within power cycle window"
    power_cycle="TRUE"
else
    echo "Not within power cycle window"
fi

echo "Rebuild Information - Hostname: $HOSTNAME ; NIGHTLY_REFRESH: $NIGHTLY_REFRESH ; Current Hour: $current_hour"

echo "Running \"nixos-rebuild boot\"..."
nixos-rebuild boot --cores $build_cores -j $build_mem --accept-flake-config
booted="$(readlink /run/booted-system/{initrd,kernel,kernel-modules})"
built="$(readlink /nix/var/nix/profiles/system/{initrd,kernel,kernel-modules})"

if [ "$NIGHTLY_REFRESH" = "poweroff-always" ]; then
    echo "Running \"nixos-rebuild switch\"..."
    nixos-rebuild switch --cores $build_cores -j $build_mem --accept-flake-config
    if [ "$power_cycle" = "TRUE" ]; then
        echo "Within poweroff window. Goodbye!"
        sleep 20s
        poweroff
    else
        echo "Not within power cycle window of 0400-0500, skipping poweroff."
    fi

elif [ "$NIGHTLY_REFRESH" = "reboot-always" ]; then
    echo "Running \"nixos-rebuild switch\"..."
    nixos-rebuild switch --cores $build_cores -j $build_mem --accept-flake-config
    if [ "$power_cycle" == "TRUE" ]; then
        echo "Machine set to always reboot and it is within the power cycle window. Rebooting now."
        sleep 20s
        reboot now
    else
        echo "Not within power cycle window of 0400-0500, skipping reboot."
    fi

elif [ "$NIGHTLY_REFRESH" = "reboot-if-needed" ]; then
    if [ "''${booted}" = "''${built}" ]; then
        echo "Reboot not necessary."
        echo "Running \"nixos-rebuild switch\"..."
        nixos-rebuild switch --cores $build_cores -j $build_mem --accept-flake-config
    elif [ "$power_cycle" == "TRUE"]; then
        echo "Reboot necessary and within reboot window. Rebooting now."
        sleep 20s
        reboot now
    else
        echo "Refresh is necessary, but it was not within the power cycle window of 0400 and 0500 so it was skipped."
    fi

else
    echo 'Environmental variable NIGHTLY_REFRESH was not set to an appropriate value ("poweroff-always", "reboot-always" or "reboot-if-needed"). Action will not be taken.'

fi
