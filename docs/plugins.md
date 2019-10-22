# Plugins

[Return Home>](/jlenv/)

## Page Contents

* [Plugins](#plugins)
  * [Approved plugins](#approved-plugins)
  * [Community plugins](#community-plugins)

See [Authoring Plugins](/jlenv/authoring-plugins.md) for instructions on how to write
new commands for jlenv or hook into its functionality.

A plugin can be installed by dropping it in as a sub-directory of
`$JLENV_ROOT/plugins`, or it can be located elsewhere on the system as long as
`jlenv-*` executables are placed in the `$PATH` and hooks are installed
accordingly somewhere in `$JLENV_HOOK_PATH`.

## Approved plugins(#approved-plugins)

These plugins are endorsed by jlenv maintainers.

* [julia-installer](https://github.com/jlenv/jlenv-installer) -
  **install, update and diagnose jlenv**.  Provides the `jlenv doctor` command.
* [julia-build](https://github.com/jlenv/julia-build) - compile and
  **install Julia**.  Provides the `jlenv install` command.
* [jlenv-vars](https://github.com/jlenv/jlenv-vars) - safely sets global and
  per-project **environment variables**
* [jlenv-each](https://github.com/jlenv/jlenv-each) - execute the same command
  **with each** installed Julia
* [jlenv-update](https://github.com/jlenv/jlenv-update) - **update jlenv** and
  installed plugins

## Community plugins(#community-plugins)

Please add your plugin here.
