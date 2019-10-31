# FAQ / Troubleshooting

[Return Home>](/jlenv/)

## Page Contents

* [FAQ / Troubleshooting](#faq--troubleshooting)
    * [What is jlenv?](#what-is-jlenv)
    * [How is this better than ...?](#how-is-this-better-than-)
    * [How do I install jlenv?](#how-do-i-install-jlenv)
    * [What is allowed in a .julia-version file?](#what-is-allowed-in-a-julia-version-file)
    * [How to verify that I have set up `jlenv` correctly?](#how-to-verify-that-i-have-set-up-jlenv-correctly)
    * [`jlenv` is installed but not working for me.](#jlenv-is-installed-but-not-working-for-me)
    * [Which shell startup file do I put `jlenv` config in?](#which-shell-startup-file-do-i-put-jlenv-config-in)

### What is jlenv?

[jlenv](https://jlenv.github.com/jlenv/readme#installation) is a tool for simple 
Julia version management.

### How is this better than ...?

See [Why jlenv?](/jlenv/why-jlenv)

### How do I install jlenv?

1. Use the [`jlenv-installer`](https://github.com/jlenv/jlenv-installer#jlenv-installer)  

   ```bash
   curl -fsSL https://github.com/jlenv/jlenv-installer/raw/master/bin/jlenv-installer | bash
   # OR
   wget -q https://github.com/jlenv/jlenv-installer/raw/master/bin/jlenv-installer -O- | bash
   ```

2. Follow to the [Documented instructions](https://jlenv.github.com/jlenv/readme#installation).

### What is allowed in a `.julia-version` file?

The string read from a `.julia-version` file must match the name of an existing 
directory in `~/.jlenv/versions/`.
The installed Julia versions are listed by the command ``jlenv` versions`.

If you're using
[julia-build](https://github.com/jlenv/julia-build#readme "Command-line tool for downloading and compiling various Julia releases"),
typically this will be one of [its Julia version names](https://github.com/jlenv/julia-build/tree/master/share/julia-build "List of available Julia versions from julia-build").

Other version managers might allow fuzzy version matching on the string read 
from `.julia-version` file, e.g. they might allow "1.0.3" (without patch suffix) 
to match the latest Julia 1.0.3 release.

**`jlenv` will not support this**: such behavior is unpredictable, hence unsafe.

### How to verify that I have set up `jlenv` correctly?

1. Check that `jlenv` is in your PATH:

    ```bash
    which jlenv
    ```

2. Check that jlenv's shims directory is in PATH:

    ```bash
    echo $PATH | grep --color=auto "$(jlenv root)/shims"
    ```

    If not, see the [`jlenv init` step](/jlenv/readme#basic-github-checkout) 
    installation instructions.

### `jlenv` is installed but not working for me.

Please search [existing issues](https://github.com/jlenv/jlenv/issues) and open 
a new one if you had problems using jlenv.

The [jlenv-doctor script](https://github.com/jlenv/jlenv-installer) 
analyzes your system setup for common problems.
You can use [Gist](https://gist.github.com) to paste the results online and 
share it in your bug report:

### Which shell startup file do I put `jlenv` config in?

Typically it's one of the following:

* bash: `~/.bash_profile` (or `~/.bashrc` on Ubuntu Desktop)
* zsh: `~/.zshrc`
* fish: `~/.config/fish/config.fish`
* other: `~/.profile`

See [Unix shell initialization](/jlenv/unix-shell-init) for more info about how config files get loaded.
