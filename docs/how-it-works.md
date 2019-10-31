# How It Works

[Return Home>](/jlenv/)

## Page Contents

* [How It Works](#how-it-works)
  * [Understanding PATH](#understanding-path)
  * [Understanding Shims](#understanding-shims)
  * [Choosing the Julia Version](#choosing-the-julia-version)
  * [Locating the Julia Installation](#locating-the-julia-installation)

At a high level, `jlenv` intercepts Julia commands using shim
executables injected into your `PATH`, determines which Julia version
has been specified by your application, and passes your commands along
to the correct Julia installation.

## Understanding PATH

When you run a command like `julia`, your operating system
searches through a list of directories to find an executable file with
that name. This list of directories lives in an environment variable
called `PATH`, with each directory in the list separated by a colon:

    /usr/local/bin:/usr/bin:/bin

Directories in `PATH` are searched from left to right, so a matching
executable in a directory at the beginning of the list takes
precedence over another one at the end. In this example, the
`/usr/local/bin` directory will be searched first, then `/usr/bin`,
then `/bin`.

## Understanding Shims

jlenv works by inserting a directory of _shims_ at the front of your
`PATH`:

    ~/.jlenv/shims:/usr/local/bin:/usr/bin:/bin

Through a process called _rehashing_, `jlenv` maintains shims in that
directory to match every Julia command across every installed version
of Julia.

Shims are lightweight executables that simply pass your command along
to jlenv. So with `jlenv` installed, when you run, say, `julia`, your
operating system will do the following:

* Search your `PATH` for an executable file named `julia`
* Find the `jlenv` shim named `julia` at the beginning of your `PATH`
* Run the shim named `julia`, which in turn passes the command along to
  jlenv

## Choosing the Julia Version

When you execute a shim, `jlenv` determines which Julia version to use by
reading it from the following sources, in this order:

1. The `JLENV_VERSION` environment variable, if specified. You can use
   the [`jlenv shell`](#jlenv-shell) command to set this environment
   variable in your current shell session.

2. The first `.julia-version` file found by searching the directory of the
   script you are executing and each of its parent directories until reaching
   the root of your filesystem.

3. The first `.julia-version` file found by searching the current working
   directory and each of its parent directories until reaching the root of your
   filesystem. You can modify the `.julia-version` file in the current working
   directory with the [`jlenv local`](#jlenv-local) command.

4. The global `~/.jlenv/version` file. You can modify this file using
   the [`jlenv global`](#jlenv-global) command. If the global version
   file is not present, `jlenv` assumes you want to use the "system"
   Julia—i.e. whatever version would be run if `jlenv` weren't in your
   path.

## Locating the Julia Installation

Once `jlenv` has determined which version of Julia your application has
specified, it passes the command along to the corresponding Julia
installation.

Each Julia version is installed into its own directory under
`~/.jlenv/versions`. For example, you might have these versions
installed:

* `~/.jlenv/versions/v0.6.0/`
* `~/.jlenv/versions/v0.6.0-rc3/`
* `~/.jlenv/versions/v0.5.0/`

Version names to `jlenv` are simply the names of the directories in
`~/.jlenv/versions`.
