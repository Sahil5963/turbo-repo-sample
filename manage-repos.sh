#!/bin/bash

# Function to execute git command in all repositories
execute_git_command() {
    command=$1
    echo "Executing in root repo:"
    if [ "$command" = "pull" ]; then
        git pull || git pull origin $(git rev-parse --abbrev-ref HEAD)
    else
        git $command
    fi
    
    for dir in apps/*; do
        if [ -d "$dir/.git" ]; then
            echo "Executing in $dir:"
            (cd "$dir" && {
                if [ "$command" = "pull" ]; then
                    git pull || git pull origin $(git rev-parse --abbrev-ref HEAD)
                else
                    git $command
                fi
            })
        fi
    done
}

# Main script
case "$1" in
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
        echo "Usage: $0 {pull|push|status|commit \"message\"}"
        exit 1
esac
