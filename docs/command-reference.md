# Command Reference

[Return Home>](/jlenv/)

## Page Contents

* [Command Reference](#command-reference)
  * [jlenv global](#jlenv-global)
  * [jlenv local](#jlenv-local)
  * [jlenv rehash](#jlenv-rehash)
  * [jlenv shell](#jlenv-shell)
  * [jlenv version](#jlenv-version)
  * [jlenv versions](#jlenv-versions)
  * [jlenv whence](#jlenv-whence)
  * [jlenv which](#jlenv-which)

Like `git`, the `jlenv` command delegates to subcommands based on its
first argument. The most common subcommands are:

## jlenv global

Sets the global version of Julia to be used in all shells by writing
the version name to the `~/.jlenv/version` file. This version can be
overridden by an application-specific `.julia-version` file, or by
setting the `JLENV_VERSION` environment variable.

```bash
jlenv global v0.6.0
```

The special version name `system` tells `jlenv` to use the system Julia
(detected by searching your `$PATH`).

When run without a version number, `jlenv global` reports the
currently configured global version.

[Return to ToC>]((#command-reference))

## jlenv local

Sets a local application-specific Julia version by writing the version
name to a `.julia-version` file in the current directory. This version
overrides the global version, and can be overridden itself by setting
the `JLENV_VERSION` environment variable or with the `jlenv shell`
command.

```bash
jlenv local v1.0.3
```

When run without a version number, `jlenv local` reports the currently
configured local version. You can also unset the local version:

```bash
jlenv local --unset
```

[Return to ToC>]((#command-reference))

## jlenv rehash

Installs shims for all Julia executables known to `jlenv` (i.e.,
`~/.jlenv/versions/*/bin/*`). Run this command after you install a new
version of Julia, or install a gem that provides commands.

```bash
jlenv rehash
```

[Return to ToC>]((#command-reference))

## jlenv shell

Sets a shell-specific Julia version by setting the `JLENV_VERSION`
environment variable in your shell. This version overrides
application-specific versions and the global version.

```bash
jlenv shell v0.6.0
```

When run without a version number, `jlenv shell` reports the current
value of `JLENV_VERSION`. You can also unset the shell version:

```bash
jlenv shell --unset
```

[Return to ToC>]((#command-reference))

## jlenv version

Displays the currently active Julia version, along with information on
how it was set.

```bash
$ jlenv version
  v0.6.0 (set by /Users/sam/.jlenv/version)
```

[Return to ToC>]((#command-reference))

## jlenv versions

Lists all Julia versions known to jlenv, that is, found in
`${JLENV_ROOT}/versions/*`.
Shows an asterisk next to the currently active version.

Options:
  --bare           Display only the version numbers
  --skip-aliases:  Do not list versions that have been symlinked.

```bash
$ jlenv versions
    v0.6.0
  * v0.6.0-rc1 (set by /Users/sam/.jlenv/version)
```

[Return to ToC>]((#command-reference))

## jlenv whence

Lists all Julia versions with the given command installed.
The list is a simple version list, similar to $(jlenv versions --bare).

Options:
  `--path`  Print the path to the version(s) of Julia.

```bash
$ jlenv whence julia
  v0.6.0
```

```bash
$ jlenv whence julia
  /tmp/jlenv.y3G/root/versions/0.7/bin/julia
  /tmp/jlenv.y3G/root/versions/2.0/bin/julia
```

[Return to ToC>]((#command-reference))

## jlenv which

Displays the full path to the executable that `jlenv` will invoke when
you run the given command.

```bash
$ jlenv which julia
  /home/deploy/.jlenv/versions/v1.0.0/bin/julia
```

[Return to ToC>]((#command-reference))
