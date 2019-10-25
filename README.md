# jlenv: Simple Julia Version Management

---

[![Build Status](https://travis-ci.com/jlenv/jlenv.svg?branch=master)](https://travis-ci.com/jlenv/jlenv) [![CodeFactor](https://www.codefactor.io/repository/github/jlenv/jlenv/badge)](https://www.codefactor.io/repository/github/jlenv/jlenv) [![Codacy Badge](https://api.codacy.com/project/badge/Grade/0d970140c2ff4547820b7f2a908620cd)](https://www.codacy.com/manual/taqtiqa-mark/jlenv_2?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=jlenv/jlenv&amp;utm_campaign=Badge_Grade)

Use jlenv to pick a Julia version for your application and guarantee
that your development environment matches production.

## jlenv Does...

* Change the global Julia version on a per-user basis.
* Support per-project Julia versions.
* Override the Julia version with an environment variable.

## jlenv Does NOT....

* Load into your shell.
* Override shell commands (`cd`, etc.).
* Have more than a one-word configuration file.
* Install Julia.
* Manage packages.
* Require changes to Julia for compatibility.
* Prompt you with warnings when you switch projects.

Further [documentation is here](https://jlenv.github.io/jlenv/).
Changelog is [here](https://jlenv.github.io/jlenv/changelog.md)

**Powerful in development.** Specify your app's Julia version once,
  in a single file. Keep all your teammates on the same page. No
  headaches running apps on different versions of Julia. Just Works™
  from the command line and with app servers like [Pow](http://pow.cx).
  Override the Julia version anytime: just set an environment variable.

**Rock-solid in production.** Your application's executables are its
  interface with ops. The Julia version
  dependency lives in one place—your app—so upgrades and rollbacks are
  atomic, even when you switch versions.

**One thing well.** [jlenv](https://github.com/jlenv/jlenv) is concerned solely
  with switching Julia versions.
  It's simple and predictable. A rich plugin ecosystem lets you tailor it to
  suit your needs. Compile your own Julia versions, or
  use the [julia-build](https://github.com/jlenv/julia-build)
  plugin to automate the process.
  See more [plugins listed here.](https://jlenv.github.io/jlenv/plugins).

## Requested Contributor Conduct

In the interest of fostering an excellent code base, we try to encourage anyone
to participate in our project. Please do likewise.
