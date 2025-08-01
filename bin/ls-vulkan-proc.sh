#!/usr/bin/env bash

## This is a simple utility to find a games exe name for use with lsfg-vk. How to use it is described here: https://github.com/PancakeTAS/lsfg-vk/wiki/Configuring-lsfg%E2%80%90vk

for pid in /proc/[0-9]*; do
    owner=$(stat -c %U "$pid" 2>/dev/null)
    if [[ "$owner" == "$USER" ]]; then
        if grep -qi 'vulkan' "$pid/maps" 2>/dev/null; then
            procname=$(cat "$pid/comm" 2>/dev/null)
            if [[ -n "$procname" ]]; then
                printf "PID %s: %s\n" "$(basename "$pid")" "$procname"
            fi
        fi
    fi
done
