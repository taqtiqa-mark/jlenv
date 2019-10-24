# Authoring plugins

[Return Home>](/jlenv/)

## Page Contents

* [Authoring plugins](#authoring-plugins)
  * [jlenv commands](#jlenv-commands)
    * [Environment](#environment)
    * [Calling other commands](#calling-other-commands)
    * [Help text](#help-text)
    * [Completions](#completions)
  * [Provide jlenv completions](#provide-jlenv-completions)
  * [jlenv hooks](#jlenv-hooks)
  
jlenv plugins provide new commands and/or hook into existing functionality of
jlenv. The following file naming scheme should be followed in a plugin project:

1. `bin/jlenv-COMMAND` for commands
1. `etc/jlenv.d/HOOK_NAME/*.bash` for hooks

## jlenv commands

A jlenv command is an executable named like `jlenv-COMMAND`. It will get
executed when a user runs `jlenv COMMAND`.
Its help will be displayed when a user runs `jlenv help COMMAND`.
It can be written in any interpreted language, but bash script is recommended
for portability.

**A plugin command cannot override any of the jlenv's built-in commands.**

### Environment

Each jlenv command runs with the following environment:

* `$JLENV_ROOT` - where jlenv versions & user data is typically in `~/.jlenv`
* `$JLENV_DIR` - the current directory of the caller
* `$PATH` - constructed to contain:
  1. jlenv's `libexec` dir with core commands
  2. `$JLENV_ROOT/plugins/*/bin` for plugin commands
  3. `$PATH` (external values)

### Calling other commands

When calling other commands, from a command, use the `jlenv-COMMAND` form
(with dash) instead of `jlenv COMMAND` (with space).

Use jlenv's core low-level commands to inspect the environment instead of doing
it manually.
For example, read the result of `jlenv-prefix` instead of constructing it
like `$JLENV_ROOT/versions/$version`.

A plugin command shouldn't have too much knowledge of jlenv's internals.

### Help text

An jlenv command should provide help text in the topmost comment of its source
code.
The help format is described in `jlenv help help`.

Here is a template for an executable called `jlenv-COMMAND`:

```bash
#!/usr/bin/env bash
#
# Summary: One line, short description of a command
#
# Usage: jlenv COMMAND \[--optional-flag\] <required-argument>
#
# More thorough help text wrapped at 70 characters that spans
# multiple lines until the end of the comment block.

set -e
\[ \-n "$jlenv\_DEBUG" \] && set -x

# Optional: Abort with usage line when called with invalid arguments
# (replace COMMAND with the name of this command)
if \[ \-z "$1" \]; then
  jlenv-help --usage COMMAND \>&2
  exit 1
fi
```

### Completions

A command can optionally provide tab-completions in the shell by outputting
completion values when invoked with the `--complete` flag.

## Provide jlenv completions

```bash
if [ "$1" = "--complete" ]; then
  echo hello
  exit
fi
```

Note: **it's important to keep the above comment intact**.
This is how jlenv detects if a command is provides completion values.

## jlenv hooks

Hooks are bash scripts named `HOOK_NAME/*.bash`, where "HOOK\_NAME" is one of:

* `exec`
* `rehash`
* `version-name`
* `version-origin`
* `which`

Hooks are looked for in `$JLENV_HOOK_PATH`, which is composed of:

1. `$JLENV_HOOK_PATH` (external value)
1. `$JLENV_ROOT/jlenv.d`
1. `/usr/local/etc/jlenv.d`
1. `/etc/jlenv.d`
1. `/usr/lib/jlenv/hooks`
1. `$JLENV_ROOT/plugins/*/etc/jlenv.d`

Hook scripts are executed at specific points during jlenv operation.
They provide a low-level entry point for integration with jlenv's functionality.
To get a better understanding of the possibilities with hooks, read the source
code of jlenv's hook-enabled commands listed above.
