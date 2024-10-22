devcon
======

This is a small tool that wraps the devcontainers/cli tool.

Why bother with it, instead of using the `devcontainer` program directly?

- The `devcontainer` command hasn't been optimised for use on the command line,
  and so requires you to specify a lot of long-winded options every time you
  use it
- Key subcommands (e.g. `down`, for stopping your containers) haven't been
  implemented in `devcontainer` yet

To put that another way, to launch my development environment I'd much rather
type this:

```sh
devcon up
devcon exec nvim
devcon down
```

That's equivalent to the following:

```sh
devcontainer \
    --workspace-folder . \
    --additional-features '{ "ghcr.io/duduribeiro/devcontainer-features/neovim:1": {} }' \
    --mount "type=bind,source=$HOME/.gitconfig,target=/home/vscode/.gitconfig" \
    --mount "type=bind,source=$HOME/.ssh,target=/home/vscode/.ssh" \
    --mount "type-bind,source=$SSH_AUTH_SOCK,target=/tmp/.ssh-auth.sock" \
    --remote-env SSH_AUTH_SOCK=/tmp/.ssh-auth.sock \
    --dotfiles-repository https://github.com/gma/nvim-config.git \
    --dotfiles-target-path ~/devcontainer-config \
    up

devcontainer \
    --workspace-folder . \
    --remote-env SSH_AUTH_SOCK=/tmp/.ssh-auth.sock \
    exec nvim

docker compose -f .devcontainer/compose.yml down  # the devcontainer project can't even shut them down!
```

Note that devcon installs Neovim as a [devcontainer feature] by default.

Environment Variables
---------------------

You can control the behaviour of `devcon` by setting a few environment
variables.

### DEVCON_DOTFILES

Can be set to the URL of a Git repository that contains your dotfiles. It will
be passed to the --dotfiles-repository argument of `devcontainer up` . I set
this in my `~/.bashrc`, so that every time I build a new devcontainer my
personal settings are installed within the container.

### DEVCON_FEATURES

Can be set to a snippet of JSON that defines the [devcontainer feature] that
you'd like to be used when building the container.

It defaults to including a feature that will compile Neovim from source.

Set it to the empty string if you'd like to disable the installation of Neovim,
but don't have any other features that you'd like to include in your
containers.

### DEVCON_USER

Defaults to `vscode`. If your container runs as a different you'll probably
want to update this. It's used to make config files available within the
container.

[devcontainer feature]: https://containers.dev/features
