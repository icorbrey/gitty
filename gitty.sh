#!/usr/bin/bash

alias _gitty_to-lower="tr '[:upper:]' '[:lower:]'"
alias _gitty_replace-whitespace="sed 's/ \+/-/g'"
alias _gitty_remove-special-characters="tr -cd '[:alnum:]._-'"

function gitty()
{
    _option=$1

    case $_option in

        "compare")
            _base_branch=$2
            _target_branch=$3
            _gitty_compare $_base_branch $_target_branch
            ;;

        "compare-current")
            _base_branch=$2
            _gitty_compare $_base_branch $(_gitty_echo-current-branch)
            ;;

        "fast-forward")
            _source_branch=$2
            _gitty_fast_forward $_source_branch
            ;;

        "rename-branch")
            _old_branch=$2
            _new_branch=$3
            _gitty_rename_branch $_old_branch $_new_branch
            ;;

        "rename-current-branch")
            _new_branch=$2
            _gitty_rename_branch $(_gitty_echo-current-branch) $_new_branch
            ;;

        "new")
            _type=$2
            _gitty_new_branch $_type
            ;;

        *)
            _gitty_help
            ;;

    esac
}

function _gitty_compare()
{
    base_branch=$1
    target_branch=$2

    format="%H %s"

    git log --pretty=format:"$format" $base_branch..$target_branch
}

function _gitty_fast_forward()
{
    current_branch=$(_gitty_echo-current-branch)
    source_branch=$1

    # Get the latest changes from the source branch
    git checkout $source_branch
    git pull

    # Merge the source branch back into the current branch
    git checkout $current_branch
    git merge $source_branch
}

function _gitty_rename_branch()
{
    old_branch=$1
    new_branch=$2

    # Rename the old local branch
    git branch -m $old_branch $new_branch

    # Delete the old remote branch
    git push origin --delete $old_branch

    # Disconnect the new local branch from its old upstream
    git branch --unset-upstream $new_branch

    # Push the new local branch to the remote
    git push origin $new_branch

    # Connect the new local branch to the new remote branch
    git push origin -u $new_branch
}

function _gitty_new_branch()
{
    branch_type=$1
    read -p "Branch #: " branch_number
    read -p "Branch title: " branch_title

    formatted_title=$(echo $branch_title \
        | _gitty_to-lower \
        | _gitty_replace-whitespace \
        | _gitty_remove-special-characters)

    branch="$branch_type/$branch_number/$formatted_title"

    git checkout -b $branch
    git push -u origin $branch
}

function _gitty_help()
{
    _usage="
usage: gitty <subcommand> [options]

    compare <base branch> <target branch>
        Prints the commits made in the target branch since it was forked from
        the base branch.

    compare-current <base branch>
        Prints the commits made in the current branch since it was forked from
        the base branch.

    fast-forward <source branch>
        Updates the source branch and merges it into the current branch.

    rename-branch <old branch> <new branch>
        Renames the old branch and pushes the new branch to origin.

    rename-current-branch <new branch>
        Renames the current branch and pushes the new branch to origin.

    new <branch type>
        Creates a new branch in the format <type>/<number>/<kebab-title>.
    "

    echo "$_usage"
}

function _gitty_echo-current-branch()
{
    git rev-parse --abbrev-ref HEAD
}
