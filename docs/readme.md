# jlenv

Use `jlenv` to pick a Julia version for your application and guarantee
that your development environment matches production.

**Powerful in development.** Specify your app's Julia version once,
  in a single file. Keep all your teammates on the same page. No
  headaches running apps on different versions of Julia. Just Works™
  from the command line and with app servers like [Pow](http://pow.cx).
  Override the Julia version anytime: just set an environment variable.

**Rock-solid in production.** Your application's executables are its
  interface with ops. The Julia version
  dependency lives in one place—your app—so upgrades and rollbacks are
  atomic, even when you switch versions.

**One thing well.** `jlenv` is concerned solely with switching Julia
  versions. It's simple and predictable. A rich plugin ecosystem lets
  you tailor it to suit your needs. Compile your own Julia versions, or
  use the [julia-build](https://github.com/jlenv/julia-build)
  plugin to automate the process.
  See more [plugins](/jlenv/plugins).

## Table of Contents

* [FAQ](/jlenv/faq-troubleshooting)
* [Why jlenv?](/jlenv/why-jlenv)
* [How It Works](/jlenv/how-it-works)
* [Command Reference](/jlenv/command-reference)
* [`jlenv` plugins](/jlenv/plugins)
* [Authoring plugins](/jlenv/authoring-plugins)
* [How to enable `jlenv` everywhere](/jlenv/edit-path)
* [Deploying with jlenv](/jlenv/deploying-jlenv)
* [Understanding binstubs](/jlenv/understanding-binstubs)
* [Unix shell initialization](/jlenv/unix-shell-init)
* [Changelog](/jlenv/changelog)

## Page Contents

* [Installation](#installation)
  * [Requirements](#requirements)
  <!-- * [Instructions](#instructions)   -->
  * [Basic GitHub Checkout](#basic-github-checkout)
    * [Upgrading with Git](#upgrading-with-git)
  * [How `jlenv` hooks into your shell](#how-jlenv-hooks-into-your-shell)
  * [Installing Julia versions](#installing-julia-versions)
    * [Installing Julia gems](#installing-julia-gems)
  * [Uninstalling Julia versions](#uninstalling-julia-versions)
  * [Uninstalling jlenv](#uninstalling-jlenv)
* [Environment variables](#environment-variables)
* [Development](#development)

## Installation

### Requirements

1. GNU [CoreUtils](https://www.gnu.org/software/coreutils/): >= 8.15 (circa 2012).
1. BASH: [bash](https://www.gnu.org/software/bash/): >= 4.3 (circa 2014)

<!-- ### Instructions

1. Install `jlenv` using the installer script.
   Note that this also installs `julia-install`, so you'll be ready to
   install other Julia versions out of the box.

2. Run `jlenv init` and follow the instructions to set up
   `jlenv` integration with your shell. This is the step that will make
   running `julia` "see" the Julia version that you choose with jlenv.
   **NOTICE:**
   In the next version of `jlenv` this behavior may move to `jlenv chjl`.
   Please comment on this change under
   [this Issue](https://github.com/jlenv/jlenv/issues/10).

3. Close your Terminal window and open a new one so your changes take
   effect.

4. That's it! Installing `jlenv` includes julia-install, so now you're ready to
   [install some other Julia versions](#installing-julia-versions) using
   ``jlenv` install`. -->

### Basic GitHub Checkout

This will get you going with the latest version of `jlenv` without needing
a systemwide install.

1. Clone `jlenv` into `~/.jlenv`.

    ```bash
    git clone https://github.com/jlenv/jlenv.git ~/.jlenv
    git fetch --tags --force
    git checkout tags/1.0.0
    ```

2. Add `~/.jlenv/bin` to your `$PATH` for access to the `jlenv`
   command-line utility.

    ```bash
    echo 'export PATH="$HOME/.jlenv/bin:$PATH"' >> ~/.bash_profile
    ```

    **Ubuntu Desktop note**: Modify your `~/.bashrc` instead of `~/.bash_profile`.

    **Zsh note**: Modify your `~/.zshrc` file instead of `~/.bash_profile`.

3. Run `~/.jlenv/bin/jlenv init` and follow the instructions to set up
   `jlenv` integration with your shell. This is the step that will make
   running `julia` "see" the Julia version that you choose with jlenv.

4. Restart your shell so that PATH changes take effect. (Opening a new
   terminal tab will usually do it.)

5. _(Optional)_ Install [julia-build](https://github.com/jlenv/julia-build),
   which provides the `jlenv install` command that simplifies the process of
   [installing new Julia versions](#installing-julia-versions).

#### Upgrading with Git

If you've installed `jlenv` manually using Git, you can upgrade to the
latest version by pulling from GitHub:

```sh
cd ~/.jlenv
git fetch --tags --force
git checkout $(git tag | sort -V | tail -1)
```

### How `jlenv` hooks into your shell

Skip this section unless you must know what every line in your shell
profile is doing.

`jlenv init` is the only command that crosses the line of loading
extra commands into your shell. Here's what `jlenv init` actually does:

1. Sets up your shims path. This is the only requirement for `jlenv` to
   function properly. You can do this by hand by prepending
   `~/.jlenv/shims` to your `$PATH`.

2. Installs autocompletion. This is entirely optional but pretty
   useful. Sourcing `~/.jlenv/completions/jlenv.bash` will set that
   up. There is also a `~/.jlenv/completions/jlenv.zsh` for Zsh
   users.

3. Rehashes shims. From time to time you'll need to rebuild your
   shim files. Doing this automatically makes sure everything is up to
   date. You can always run `jlenv rehash` manually.

4. Installs the `sh` dispatcher. This bit is also optional, but allows
   `jlenv` and plugins to change variables in your current shell, making
   commands like `jlenv shell` possible. The `sh` dispatcher doesn't do
   anything crazy like override `cd` or hack your shell prompt, but if
   for some reason you need `jlenv` to be a real script rather than a
   shell function, you can safely skip it.

Run `jlenv init -` for yourself to see exactly what happens under the
hood.

### Installing Julia versions

The `jlenv install` command doesn't ship with `jlenv` out of the box, but
is provided by the [julia-build](https://github.com/jlenv/julia-build) project.
If you installed it either as part of GitHub checkout process outlined above,
you should be able to:

```bash
# list all available versions:
jlenv install -l

# install a Julia version:
jlenv install v1.0.3
```

Alternatively to the `install` command, you can download and compile
Julia manually as a subdirectory of `~/.jlenv/versions/`. An entry in
that directory can also be a symlink to a Julia version installed
elsewhere on the filesystem. `jlenv` doesn't care; it will simply treat
any entry in the `versions/` directory as a separate Julia version.

### Uninstalling Julia versions

As time goes on, Julia versions you install will accumulate in your
`~/.jlenv/versions` directory.

To remove old Julia versions, simply `rm -rf` the directory of the
version you want to remove. You can find the directory of a particular
Julia version with the `jlenv prefix` command, e.g. `jlenv prefix 1.0.0`.

The [julia-build](https://github.com/jlenv/julia-build) plugin provides an
`jlenv uninstall` command to automate the removal process.

### Uninstalling jlenv

The simplicity of `jlenv` makes it easy to temporarily disable it, or
uninstall from the system.

1. To **disable** `jlenv` managing your Julia versions, simply remove the
  `jlenv init` line from your shell startup configuration. This will
  remove `jlenv` shims directory from PATH, and future invocations like
  `julia` will execute the system Julia version, as before jlenv.

  `jlenv` will still be accessible on the command line, but your Julia
  apps won't be affected by version switching.

1. To completely **uninstall** jlenv, perform step (1) and then remove
   its root directory. This will **delete all Julia versions** that were
   installed under `"$(jlenv root)/versions/"` directory:

  ```bash
  rm -rf $(jlenv root)
  ```

## Environment variables

You can affect how `jlenv` operates with the following settings:

name | default | description
-----|---------|------------
`JLENV_VERSION` | | Specifies the Julia version to be used. Also see [`jlenv shell`](/jlenv/command-reference#jlenv-shell)
`JLENV_ROOT` | `~/.jlenv` | Defines the directory under which Julia versions and shims reside.<br>Also see `jlenv root`
`JLENV_DEBUG` | | Outputs debug information.<br>Also as: `jlenv --debug <subcommand>`
`JLENV_HOOK_PATH` | [See Authoring Plugins][/authoring-plugins#jlenv-hooks] | Colon-separated list of paths searched for `jlenv` hooks.
`JLENV_DIR` | `$PWD` | Directory to start searching for `.julia-version` files.

## Development

The `jlenv` source code is [hosted on GitHub](https://github.com/jlenv/jlenv).
It's clean, modular, and easy to understand, even if you're not a shell hacker.

Tests are executed using [Bats](https://github.com/sstephenson/bats):

```bash
bats test/run
```

Please feel free to submit pull requests and file bugs on the
[issue tracker](https://github.com/jlenv/jlenv/issues).
