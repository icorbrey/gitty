# gitty

Quality of life utility scripts for Git.

## Usage

### Compare two branches

`gitty compare <base branch> <target branch>`

Prints the commits made in the target branch since it was forked from the base branch.

### Compare current branch to a base branch

`gitty compare-current <base branch>`

Prints the commits made in the current branch since it was forked from the base branch.

### Fast-forward current branch with base branch

`gitty fast-forward <source branch>`

Updates the source branch and merges it into the current branch.

### Rename a branch

`gitty rename-branch <old branch> <new branch>`

Renames the old branch and pushes the new branch to origin.

### Rename the current branch

`gitty rename-current-branch <new branch>`

Renames the current branch and pushes the new branch to origin.

## Installation

```
git clone https://github.com/icorbrey/gitty.git
cd ./gitty
./install.sh
```

## License

This project is licensed under the [GPL v3 license][license].

[license]: https://github.com/icorbrey/gitty/blob/master/LICENSE
