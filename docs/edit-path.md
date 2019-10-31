# How to edit path

[Return Home>](/jlenv/)

## Page Contents

* [How to edit path](#how-to-edit-path)
  * [Post-receive git hook](#post-receive-git-hook)
  * [cron jobs](#cron-jobs)
  * [TextMate](#textmate)
  * [Sublime Text 2](#sublime-text-2)
  * [Capistrano](#capistrano)
  
The beauty of `jlenv` is that **it doesn't require special integrations** with
any tools, shells or environments. I
ts shims directory just needs to be present in the path and `jlenv` will take
care of the rest.

The following is practial info on how to add `~/.jlenv/shims` to `PATH` in
various programs/environments.

## Post-receive git hook

The post-receive script that runs on a remote machine as a result of `git push`
will run in a restricted shell and therefore won't source any init files
described in [Unix shell initialization](/jlenv/unix-shell-init).
As a consequence, `jlenv` won't be present in `PATH` even if you configured it to
be enabled when you log in over SSH.

The solution is to explicitly define `PATH` as descibed in cron section below.

## cron jobs

Explicitly define `PATH` at the top of your crontab file (Assumes `deploy` user):

```bash
PATH=/home/deploy/.jlenv/shims:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin
```

## TextMate

In _Preferences → Variables_, prepend this to `PATH`:

```bash
$HOME/.jlenv/shims:
```

## Sublime Text 2

_Tools → Build System → New Build System_:

```json
{
  "cmd": \["julia", "$file"\],
  "file\_regex": "^(...\*?):(\[0-9\]\*):?(\[0-9\]\*)",
  "selector": "source.julia",
  "path": "$HOME/.jlenv/shims:$PATH"
}
```

Save this new build system as "Julia jlenv" or similar so you can distinguish
it from the built-in "Julia" build system.

## Capistrano

Add to your Capistrano recipe:

```ruby
set :default\_environment, {
  'PATH' => "$HOME/.jlenv/shims:$PATH"
}
```
