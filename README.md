devcon
======

This is a small tool that extends the functionality of the [devcontainers/cli]
tool.

Why might you want to use it, rather than just using `devcontainer` directly?

If using the `devcontainer` command to build and launch a container that has
access to my SSH keys, Git config, and my standard dotfiles, I would need all
these options:

```sh
devcontainer \
    --workspace-folder . \
    --mount "type=bind,source=$HOME/.gitconfig,target=/home/vscode/.gitconfig" \
    --mount "type=bind,source=$HOME/.ssh,target=/home/vscode/.ssh" \
    --mount "type-bind,source=$SSH_AUTH_SOCK,target=/tmp/.ssh-auth.sock" \
    --remote-env SSH_AUTH_SOCK=/tmp/.ssh-auth.sock \
    --dotfiles-repository https://github.com/gma/dotfiles.git \
    up
```

Yeah, that's not happening.

We need a way to automate those settings. `devcon` will take care of preparing
all those options for you, so you can just type:

```sh
devcon up
```

In addition to setting these common switches, you can pass other options to
`devcon` and it will pass them through to `devcontainer`.

## Supported commands

`devcon` supports all the commands that `devcontainer` supports.

Most `devcontainer` commands are called directly, while `build`, `exec`, and
`up` are called with some default options.

These extra options will:

- Make your `~/.gitconfig` file available within the container
- Make your host computer's ssh-agent available within the container (so you
  can login to stuff with your SSH keys)
- Install your dotfiles within the container (if you set `DEVCON_DOTFILES` —
  see below)
- Install a recent version of Neovim from source, inside the container (you can
  override this behaviour if you like — see below)

In addition, it adds two new commands:

- `devcon down` will stop your containers, by running `docker compose down`
- `devcon login` will run `docker exec` to launch a shell inside the container

To put that another way, to launch, use, and then shut down my development
environment I can just type this:

```sh
devcon up
devcon login  # equivalent to `devcon exec /bin/bash`
devcon down
```

Environment Variables
---------------------

You can control the behaviour of `devcon` by setting a few environment
variables.

### DEVCON_DOTFILES

Default: Unset

Can be set to the URL of a Git repository that contains your dotfiles. It will
be passed to the `--dotfiles-repository` argument of `devcontainer up` . I set
this in my host computer's `~/.bashrc`, so that every time I build a new
devcontainer my personal settings are installed within the container.

### DEVCON_FEATURES

Default: `'{ "ghcr.io/duduribeiro/devcontainer-features/neovim:1": {} }'`

Can be set to a snippet of JSON that defines the [devcontainer feature] that
you'd like to be used when building the container.

It defaults to including a feature that will compile Neovim from source.

Set it to the empty string if you'd like to disable the installation of Neovim,
but don't have any other features that you'd like to include in your
containers.

### DEVCON_USER

Default: `vscode`

If your container runs as a different you'll probably want to update this. It's
used to determine the user's home directory inside the container.

[devcontainers/cli]: https://github.com/devcontainers/cli
[devcontainer feature]: https://containers.dev/features
