# Deploying with jlenv

[Return Home>](/jlenv/)

## Page Contents

* [Deploying with jlenv](#deploying-with-jlenv)
  * [Ensure consistent PATH for processes](#ensure-consistent-path-for-processes)
  
Setting up `jlenv` on a production server is exactly the same as in development. 
Some considerations for a hypothetical deployment strategy:

* It is suggested that there is a single user for deployment, e.g. "deploy" user
* `JLENV_ROOT` is at the default location: `/home/deploy/.jlenv`
* Julia versions are either installed or symlinked to `~/.jlenv/versions`
* `jlenv` version 1.0 or greater is recommended.

Users of Chef may find this project useful:

* [jlenv-cookbook](https://github.com/jlenv/jlenv-cookbook#readme)

## Ensure consistent PATH for processes

Interactive, non-interactive shells, cron jobs, and similar processes for the 
"app" user all must ensure that `jlenv` is present in the `PATH`:

```bash
export PATH=~/.jlenv/shims:~/.jlenv/bin:"$PATH"
```
