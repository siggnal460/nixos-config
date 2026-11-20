#!/usr/bin/env nu

def build_cores [] {
    let threads = (nproc | into int)
    if $threads > 8 { $threads / 8 | math round | into int } else { 1 }
}

def build_jobs [] {
    let mem_gb = (sys mem | get total) / 1gb
    if $mem_gb > 8 { $mem_gb / 8 | math round | into int } else { 1 }
}

# Extra nix args to pass through when --limit is active, empty otherwise.
def resource_args [limit: bool] {
    if $limit {
        ["--cores" (build_cores | into string) "--max-jobs" (build_jobs | into string)]
    } else {
        []
    }
}

def print_header [text: string] {
    print $"(ansi blue_reverse)------ ($text) ------(ansi reset)"
}

def print_error [text: string] {
    print $"(ansi red)($text)(ansi reset)"
}

def print_success [text: string] {
    print $"(ansi green)($text)(ansi reset)"
}

def print_warning [text: string] {
    print $"(ansi yellow)($text)(ansi reset)"
}

def rebuild_running [] {
    (ps | where name in ["nix" "nh" "nixos-rebuild"] | length) > 0
}

def repo_changes [] {
    (git status -s | str length) > 0
}

# Stashes local changes (if any) so a rebase can proceed cleanly, returns whether a stash was made.
def stash_changes [] {
    if not (repo_changes) {
        false
    } else {
        git stash push -u -m "nix-switch autostash"
        $env.LAST_EXIT_CODE == 0
    }
}

def pop_stash [] {
    git stash pop
    $env.LAST_EXIT_CODE == 0
}

# Formats the repo in place, returns whether it succeeded.
def format_repo [] {
    sudo treefmt
    $env.LAST_EXIT_CODE == 0
}

# Builds without switching, used as a pre-commit sanity check.
def build_config [flake_name: string flake_folder: string limit: bool] {
    nh os build -H $flake_name $flake_folder -- --accept-flake-config ...(resource_args $limit)
    $env.LAST_EXIT_CODE == 0
}

def switch_config [flake_name: string flake_folder: string limit: bool] {
    nh os switch -H $flake_name $flake_folder -- --accept-flake-config ...(resource_args $limit)
    $env.LAST_EXIT_CODE == 0
}

# Quick-and-dirty utility to update a Nix + Home Manager system and keep it's changes in sync with a remote Git repository
def main [
    --autoformat (-a)                                                  # Force formatting with treefmt even when --short is used. Formatting always runs otherwise.
    --branch (-b): string = "master"                                   # The branch from which to pull or to which to push
    --full (-f)                                                        # Will also update the flake lock file to perform a full upgrade.
    --hardware (-h)                                                    # Will also update the hosts hardware-configuration.nix with the current hardware setup.
    --limit (-l)                                                       # Automatically limit update process to a small amount of cores/threads based on system CPU threads and RAM. Useful for expensive build processes.
    --path (-p): string = "/etc/nixos"                                 # Filepath to the folder containing the flake.nix.
    --name (-n): string                                                # Use the flake with this name. Defaults to the hostname if not specified.
    --quit-on-changes (-q)                                             # Exit the script if there are local changes. No effect when used with -s flag.
    --remote (-r): string = "origin"                                   # Your origin repository name.
    --short (-s)                                                       # Perform a simple nixos-rebuild switch with no interaction to git
    --url (-u): string = "git@github.com:siggnal460/nixos-config.git" # Your origin repository SSH url, in the vein of git@github.com:<username>/<repo>.git
] {
    if (rebuild_running) {
        print "There appears to already be a rebuild in place. Exiting."
        exit 0
    }

    mut commit_msg = ""
    let flake_folder = $path
    let flake_path = $"($flake_folder)/flake.nix"
    let folder_type = $flake_folder | path type
    let flake_name = if $name != null { $name } else { hostnamectl hostname }

    if not ($flake_path | path exists) {
        print_error $"Tried to update from ($flake_path), but it does not exist. Set alternative flake path with --path."
        exit 1
    }
    if $folder_type != dir {
        print_error $"Tried to update from ($flake_folder), but it is not a directory, it's a ($folder_type). --path needs to be set to the directory the flake.nix is located within."
        exit 1
    }

    if $short {
        if $autoformat and not (format_repo) {
            print_error "Formatting failed."
            exit 1
        }
        git add $flake_folder
        if not (switch_config $flake_name $flake_folder $limit) {
            print_error "Switch failed."
            exit 1
        }
        print_success "Switch complete"
        print ""
        exit 0
    }

    cd $flake_folder

    print_header "BUILD INFORMATION"
    print $"Flake Path: ($flake_folder)"
    print $"Flake Name: ($flake_name)"
    print $"Repo URL: ($url)"
    print $"Branch: ($branch)"
    print $"Remote: ($remote)"
    print $"Update flake.lock: ($full)"
    print $"Limit Build Resources: ($limit)"
    print ""

    print_header "CHECKING REMOTE"
    let stashed = (stash_changes)
    print "Fetching from github..."
    git fetch $remote $branch
    git pull --rebase $remote $branch
    if $env.LAST_EXIT_CODE != 0 {
        print_error "Rebase failed. Resolve the conflict manually, then re-run."
        exit 1
    }
    if $stashed {
        if not (pop_stash) {
            print_error "Restoring your local changes conflicted with the pulled changes. Resolve the conflict manually (see `git status`), then re-run."
            exit 1
        }
        print_success "Local changes restored on top of the pulled commits."
    }
    print_success "Pull complete"
    print ""

    if $hardware {
        print_header "UPDATING HARDWARE CONFIG"
        nixos-generate-config --show-hardware-config
            | save --force $"($flake_folder)/host/($flake_name)/hardware-configuration.nix"
    }

    print_header "FORMATTING FILES"
    if not (format_repo) {
        print_error "Formatting failed. Fix the reported errors before committing."
        exit 1
    }
    print ""

    print_header "VALIDATING CONFIGURATION"
    if not (build_config $flake_name $flake_folder $limit) {
        print_error "Build failed. Fix the configuration before committing."
        exit 1
    }
    print_success "Build check passed"
    print ""

    print_header "CHECKING FOR CHANGES"
    if (repo_changes) {
        if $quit_on_changes {
            print "Changes found with --quit-on-changes flag active. Exiting."
            exit 0
        }
        git add $flake_folder
        print "Uncommitted changes found:"
        git diff --staged
        print "Please enter a commit message (Ctrl-C to exit without committing):"
        $commit_msg = (input)
        git add $flake_folder
        print_success "Added changes to buffer."
        git commit -m $commit_msg
        print_success "Committed changes."
    } else {
        print "No changes found"
    }
    print ""

    if $full {
        print_header "UPDATING FLAKE.LOCK"
        print "Checking for updates..."
        sudo nix flake update
        print ""

        if not (repo_changes) {
            print_success "No update for flake.lock found"
        } else {
            git add $flake_folder
            if $commit_msg != "" {
                git commit --amend --no-edit
                print_success "Added flake.lock changes to commit."
            } else {
                $commit_msg = "Updated flake.lock"
                git commit -m $commit_msg
                print_success "Committed with \"Updated flake.lock\""
            }
        }
        print ""
    }

    print_header "SWITCHING TO NEW CONFIGURATION"
    if not (switch_config $flake_name $flake_folder $limit) {
        print_error "Switch failed. Not pushing to remote."
        exit 1
    }
    print_success "Switch complete"
    print ""

    print_header "PUSHING TO REMOTE"
    if $remote in (git remote | lines) {
        git remote set-url $remote $url
    } else {
        git remote add $remote $url
    }
    git push $remote $branch
    print ""

    print_header "SYNCING MACHINES"
    ansible-playbook -i $"($flake_folder)/ansible/inventory.ini" $"($flake_folder)/ansible/sync_hosts.yml" --limit=nix_machines:!(hostnamectl hostname)

    print_success "Update complete"
}
