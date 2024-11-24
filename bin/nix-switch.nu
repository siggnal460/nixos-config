#!/usr/bin/env nu

def build_cores [ ] -> int {
    let threads = nproc | into int

    if $threads > 8 { ($threads / 8 | math round | into int) } else { 1 }
}

def build_jobs [ ] -> int {
    let mem = sys mem | get total | into string | str replace "GiB" "" | into float

    if $mem > 8 { ($mem / 8 | math round | into int) } else { 1 }
}

def print_header [ text: string ] -> string {
    print $"(ansi blue_reverse)------ ($text) ------(ansi reset)"
}

def print_error [ text: string ] -> string {
    print $"(ansi red)($text)(ansi reset)"
}

def print_success [ text: string ] -> string {
    print $"(ansi green)($text)(ansi reset)"
}

def print_warning [ text: string ] -> string {
    print $"(ansi yellow)($text)(ansi reset)"
}

def format_nix_files [ ] {
    let nix_files = ls ...(glob **/*.{nix})
    $nix_files | each { |file| print $"Formatting ($file.name)..."; nixfmt ($file.name) }
}

def update [ flake_name: string flake_folder: string limit: bool ] {
    if $limit == true {
        nh os switch -H $flake_name $flake_folder -- --accept-flake-config --cores build_cores -j build_jobs
    } else {
        nh os switch -H $flake_name $flake_folder -- --accept-flake-config
    }
}

def repo_changes [ ] -> bool {
    if (git status -s | str length) > 0 { true } else { false }
}

# Quick-and-dirty utility to update a Nix + Home Manager system and keep it's changes in sync with a remote Git repository
def main [
    --branch (-b): string = "master"   # The branch from which to pull or to which to push
    --full (-f)                        # Will also update the flake lock file to perform a full upgrade.
    --limit (-l)                       # Automatically limit update process to a small amount of cores/threads. Useful for expensive build processes. Amount is based on system CPU threads and RAM.
    --path (-p): string = "/etc/nixos" # Filepath to the folder containing the flake.nix.
    --name (-n): string                # Use the flake with this name. Defaults to the hostname if not specified.
    --remote (-r): string = "origin"   # Your origin repository name.
] {
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

    cd $flake_folder

    print_header "BUILD INFORMATION"
    print $"Flake Path: ($flake_folder)"
    print $"Flake Name: ($flake_name)"
    print $"Branch: ($branch)"
    print $"Remote: ($remote)"
    print $"Update flake.lock: ($full)"
    print $"Limit Build Resources: ($limit)"
    print "\n"

    print_header "FORMATTING NIX FILES"
    print "Formatting all nix files with nixfmt..."
    format_nix_files
    print_success "Nix files formatted!"
    print "\n"

    print_header "CHECKING FOR CHANGES"
    if (repo_changes) {
	git add .
        print "Uncommitted changes found:"
        git diff --staged
        print "Please enter a commit message (Ctrl-C to exit without committing):"
        $commit_msg = (input)
        git add .
        print_success "Added changes to buffer."
        git commit -m $commit_msg
        print_success "Committed changes."
    } else {
        print "No changes found"
    }
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
	    git add .
            git commit -m $commit_msg
            print_success "Added flake.lock changes to commit."
        } else if $commit_msg == "" {
            print "flake.lock updates found."
	    git add .
            $commit_msg = "Updated flake.lock"
            git commit -m $commit_msg
            print_success "Committed with \"Updated flake.lock\""
        }
        print "\n"
    }

    print_header "CHECKING REMOTE"
    print "Fetching from github..."
    git fetch $remote $branch
    git pull $remote $branch
    print_success "Pull complete"
    print "\n"

    print_header "SWITCHING TO NEW CONFIGURATION"
    try {
        update $flake_name $flake_folder $limit
    } catch {
        |err| $err.msg
    	git reset --soft HEAD~1
	exit 1
    }
    print_success "Switch complete"
    print "\n"

    print_header "PUSHING TO REMOTE"
    git push $remote $branch
    print "\n"

    print_success "Update complete"
}
