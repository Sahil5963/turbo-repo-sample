#!/bin/bash

# Function to print a table header
print_table_header() {
    printf "\n+%-20s+%-50s+\n" "$(printf '%0.s-' {1..20})" "$(printf '%0.s-' {1..50})"
    printf "| %-19s | %-49s |\n" "Repository" "Status"
    printf "+%-20s+%-50s+\n" "$(printf '%0.s-' {1..20})" "$(printf '%0.s-' {1..50})"
}

# Function to print a table row
print_table_row() {
    printf "| %-19s | %-49s |\n" "$1" "$2"
}

# Function to print a table footer
print_table_footer() {
    printf "+%-20s+%-50s+\n" "$(printf '%0.s-' {1..20})" "$(printf '%0.s-' {1..50})"
}

# Function to clone or pull a repository
clone_or_pull() {
    repo_url=$1
    target_dir=$2
    if [ ! -d "$target_dir" ]; then
        print_table_row "$target_dir" "Cloning..."
        output=$(git clone $repo_url $target_dir 2>&1)
        print_table_row "$target_dir" "Cloned successfully"
    else
        print_table_row "$target_dir" "Pulling latest changes..."
        output=$(cd $target_dir && git pull 2>&1)
        print_table_row "$target_dir" "Pulled successfully"
    fi
}

# Function to execute git command in all repositories
execute_git_command() {
    command=$1
    print_table_header
    print_table_row "Root repo" "Executing $command..."
    output=$(git $command 2>&1)
    print_table_row "Root repo" "${output:0:47}..."
    
    for dir in apps/*; do
        if [ -d "$dir/.git" ]; then
            print_table_row "$dir" "Executing $command..."
            output=$(cd "$dir" && git $command 2>&1)
            print_table_row "$dir" "${output:0:47}..."
        fi
    done
    print_table_footer
}

# Main script
case "$1" in
    init)
        print_table_header
        clone_or_pull "https://github.com/Lavish1999/backend.git" "apps/backend"
        # Add more repositories here if needed
        print_table_footer
        ;;
    pull)
        execute_git_command "pull"
        ;;
    push)
        execute_git_command "push"
        ;;
    status)
        execute_git_command "status"
        ;;
    commit)
        message="${@:2}"
        execute_git_command "commit -am \"$message\""
        ;;
    *)
        echo "Usage: $0 {init|pull|push|status|commit \"message\"}"
        exit 1
esac
