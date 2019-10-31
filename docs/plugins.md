# Plugins

[Return Home>](/jlenv/)

## Page Contents

* [Plugins](#plugins)
  * [`jlenv` Org plugins](#jlenv-org-plugins)
  * [Community plugins](#community-plugins)

See [Authoring Plugins](/jlenv/authoring-plugins.md) for instructions on how to write
new commands for `jlenv` or hook into its functionality.

A plugin can be installed by dropping it in as a sub-directory of
`$JLENV_ROOT/plugins`, or it can be located elsewhere on the system as long as
`jlenv-*` executables are placed in the `$PATH` and hooks are installed
accordingly somewhere in `$JLENV_HOOK_PATH`.

## `jlenv` Org plugins(#jlenv-org-plugins)

These plugins are maintained in the `jlenv` organisation.  They aim to be
compatible with jlenv.  Eventually these may be incorporated into jlenv.

* [julia-installer](https://github.com/jlenv/jlenv-installer) -
  **install, update and diagnose jlenv**.  Provides the ``jlenv` doctor` command.
<!-- * [julia-install](https://github.com/jlenv/julia-install) - compile and
  **install Julia**.  Provides the ``jlenv` install` command. -->
* [jlenv-vars](https://github.com/jlenv/jlenv-vars) - safely sets global and
  per-project **environment variables**
* [jlenv-each](https://github.com/jlenv/jlenv-each) - execute the same command
  **with each** installed Julia
* [jlenv-update](https://github.com/jlenv/jlenv-update) - **update jlenv** and
  installed plugins

## Community plugins(#community-plugins)

Please add your plugin here.
