# Understanding Binstubs

[Return Home>](/jlenv/)

## Page Contents

* [Understanding Binstubs](#understanding-binstubs)
  * [Context](#context)
  * [Julia Compiled Packages](#julia-compiled-packages)
    * [PackageCompile.jl](#packagecompilejl)
    * [BinaryBuilder.jl   BinaryProvider.jl](#binarybuilderjl--binaryproviderjl)
  * [jlenv](#jlenv)
  * [Project-specific binaries](#project-specific-binaries)
    * [Hand generated binstubs](#hand-generated-binstubs)
    * [Manually created binstubs](#manually-created-binstubs)
    * [Adding project-specific binstubs to PATH](#adding-project-specific-binstubs-to-path)

## Context

Dynamic languages such as Julia, Python, Ruby or R have the concept of binstubs
as firstclass citizens when it comes to building an executable.
Binstubs are wrapper scripts around executables (sometimes referred to as
"binaries", although they don't have to be compiled) whose purpose is to prepare
the environment before dispatching the call to the original executable/script.

In the Julia world compiled packages/projects are the first class citizens.

Binstubs can be written in any language, so Julia binstubs are possible but they
are not the default executable that Julia generates when installing a package
that contains executables.

## Julia Compiled Packages

### PackageCompile.jl

To be completed.

### BinaryBuilder.jl + BinaryProvider.jl

To be completed.

## jlenv

jlenv adds its own "shims" directory to `$PATH` which contains binstubs for
every executable related to Julia.
There are binstubs for `julia` and `juliac` across each installed Julia version.

When you call `julia` on the command-line, it results in this call chain:

1. `$JLENV_ROOT/shims/julia` (jlenv shim)
1. `$JLENV_ROOT/versions/1.0.3/bin/julia` (original)

A `jlenv` shim, presented here in a slightly simplified form, is a short shell script:

```bash
#!/usr/bin/env bash
export jlenv\_ROOT="$HOME/.jlenv"
exec jlenv exec "$(basename "$0")" "$@"
```

The purpose of jlenv's shims is to route every call to a julia executable
through `jlenv exec`, which ensures it gets executed with the right Julia
version.

## Project-specific binaries

When you run `your-bin-exe` within your project's directory, `jlenv` can ensure
that it gets executed with the selected _Julia version_ configured for that
project.
Further, Julia's package manager will ensure that the right _version of your-bin-exe_
gets activated.
In fact, Pkg.jl will simply activate the correct version even if your project
contains a newer version.
In the context of a project, this is the desired behavior.
It ensures the right versions of dependencies get activated, ensuring a
consistent julia runtime environment.

### Hand generated binstubs

Hand generated binstubs for executables contained in your project's TOML:

_You are encouraged to check these binstubs in the project's version control so
your colleagues might benefit from them._

This creates, for example, `./bin/my-exe` (simplified version shown):

```julia
#!/usr/bin/env julia
using Pkg
# Prepares the $LOAD\_PATH by adding to it lib directories of all Packages in the
# project's TOML file.
using Example
Example.hello("$@") # Arg parsing is done within `hello(...)`
```

`my-exe` can now be easily run with just `bin/my-exe`.

### Manually created binstubs

Now that you know that binstubs are simple scripts written in any language and
understand their purpose, you should consider creating some binstubs for your
project or your local development environment.

For instance, in the context of a web application, a manually generated binstub
to run [Genie](https://genieframework.com/) could be in `./bin/genie`:

```bash
#!/usr/bin/env julia
using Pkg
using Genie
using MyWebApp # add my web application router logic etc.
startup()
```

Using `bin/genie` now ensures that [Genie](https://genieframework.com/) will
run in the exact same environment as the application: same Julia version,
same Pkg dependencies.
This is true even if the binstub was called from outside the app, for instance
as `/path/to/app/current/bin/genie`.

### Adding project-specific binstubs to PATH

Assuming the binstubs for a project are in the local `bin/` directory, you can
even go a step further to add the directory to shell `$PATH` so that `my-exe`
can be invoked without the `bin/` prefix:

```bash
export PATH="./bin:$PATH"
```

However, doing so on a system that other people have write access to (such as a
shared host) [is a security risk](https://github.com/rbenv/rbenv/issues/309).
For extra security, you can make a script/shell function to add only the current
project's `bin/` directory to `$PATH`:

```bash
export PATH="$PWD/bin:$PATH"
hash -r 2>/dev/null || true
```

The downside of the more secure approach is that you have to execute it
per-project instead of setting it once globally.

See also: [direnv](https://github.com/zimbatm/direnv).
