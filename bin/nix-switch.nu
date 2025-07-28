#!/usr/bin/env nu

def build_cores [ ] {
    let threads = nproc | into int

    if $threads > 8 { ($threads / 8 | math round | into int) } else { 1 }
}

def build_jobs [ ] {
    #let mem = sys mem | get total | into string | str replace "GiB" "" | into float

    #if $mem > 8 { ($mem / 8 | math round | into int) } else { 1 }
}

def print_header [ text: string ] {
    print $"(ansi blue_reverse)------ ($text) ------(ansi reset)"
}

def print_error [ text: string ] {
    print $"(ansi red)($text)(ansi reset)"
}

def print_success [ text: string ] {
    print $"(ansi green)($text)(ansi reset)"
}

def print_warning [ text: string ] {
    print $"(ansi yellow)($text)(ansi reset)"
}

def update [ flake_name: string flake_folder: string limit: bool ] {
    if $limit == true {
        #nh os switch -H $flake_name $flake_folder -- --accept-flake-config --cores build_cores -j build_jobs
    	print "Limit not yet implemented"
    } else {
        nh os switch -H $flake_name $flake_folder -- --accept-flake-config
    }
}

def repo_changes [ ] {
    if (git status -s | str length) > 0 { true } else { false }
}

# Quick-and-dirty utility to update a Nix + Home Manager system and keep it's changes in sync with a remote Git repository
def main [
    --branch (-b): string = "master"   					# The branch from which to pull or to which to push
    --full (-f)                        					# Will also update the flake lock file to perform a full upgrade.
    --hardware (-h)                        				# Will also update the hosts hardware-configuration.nix with the current hardware setup.
    --limit (-l)                       					# Automatically limit update process to a small amount of cores/threads. Useful for expensive build processes. Amount is based on system CPU threads and RAM.
    --path (-p): string = "/etc/nixos" 					# Filepath to the folder containing the flake.nix.
    --name (-n): string                					# Use the flake with this name. Defaults to the hostname if not specified.
    --quit-on-changes (-q)                		        # Exit the script if there are local changes. No effect when used with -s flag.
    --remote (-r): string = "origin"   					# Your origin repository name.
    --short (-s)                    					# Perform a simple nixos-rebuild switch with no interaction to git
    --url (-u): string = "git@github.com:siggnal460/nixos-config.git"   # Your origin repository SSH url, in the vein of git@github.com:<username>/<repo>.git
] {
    if (ps | where name == 'nix' | length) > 0  {
        print "There appears to already be a rebuild in place. Exiting."
        exit 0
    }

    mut commit_msg = ""
    let flake_folder = $path
    let flake_path = ($flake_folder + "/flake.nix")
    let folder_type = $flake_folder | path type
    let flake_name = if $name != null { $name } else { (hostnamectl hostname) }

    if not ($flake_path | path exists) {
        print_error $"Tried to update from ($flake_path), but it does not exist. Set alternative flake path with --path."
        exit 1
    }
    if ($folder_type != dir) {
        print_error $"Tried to update from ($flake_folder), but it is not a directory, it's a ($folder_type). --path needs to be set to the directory the flake.nix is located within."
        exit 1
    }

    if $short {
    	git add /etc/nixos
        update $flake_name $flake_folder $limit
        print_success "Switch complete"
        print "\n"
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
    print "\n"

    if $hardware {
    	print_header "UPDATING HARDWARE CONFIG"
    	nixos-generate-config --show-hardware-config | save --force $"/etc/nixos/host/($flake_name)/hardware-configuration.nix"
    }

    print_header "FORMATTING FILES"
    do -i {sudo treefmt}
    print "\n"

    print_header "CHECKING FOR CHANGES"
    if (repo_changes) {
        if $quit_on_changes {
            print "Changes found with --quit-on-changes flag active. Exiting."
            exit 0
        }
    	git add /etc/nixos
        print "Uncommitted changes found:"
        git diff --staged
        print "Please enter a commit message (Ctrl-C to exit without committing):"
        $commit_msg = (input)
        git add /etc/nixos
        print_success "Added changes to buffer."
        git commit -m $commit_msg
        print_success "Committed changes."
    } else {
        print "No changes found"
    }
    print "\n"

    print_header "CHECKING REMOTE"
    print "Fetching from github..."
    git fetch $remote $branch
    git pull --rebase $remote $branch
    print_success "Pull complete"
    print "\n"

    if $full {
        print_header "UPDATING FLAKE.LOCK"
        print "Checking for updates..."
        sudo nix flake update
        print "\n"

    	if not (repo_changes) {
            print_success "No update for flake.lock found"
    	} else if $commit_msg != "" {
            print "flake.lock updates found."
    	    git reset --soft HEAD~1
    	    git add /etc/nixos
            git commit -m $commit_msg
            print_success "Added flake.lock changes to commit."
        } else if $commit_msg == "" {
            print "flake.lock updates found."
       	    git add /etc/nixos
            $commit_msg = "Updated flake.lock"
            git commit -m $commit_msg
            print_success "Committed with \"Updated flake.lock\""
        }
        print "\n"
    }

    print_header "SWITCHING TO NEW CONFIGURATION"
    update $flake_name $flake_folder $limit
    print_success "Switch complete"
    print "\n"

    print_header "PUSHING TO REMOTE"
    git remote remove $remote
    git remote add $remote $url
    git push $remote $branch
    print "\n"

    print_header "SYNCING MACHINES"
    ansible-playbook -i /etc/nixos/ansible/inventory.ini /etc/nixos/ansible/sync_hosts.yml --limit=nix_machines:!(hostnamectl hostname)

    print_success "Update complete"
}
