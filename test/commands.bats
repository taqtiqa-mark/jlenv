#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

@test "commands" {
  run jlenv2 commands
  assert_success
  refute_output ""
  # commands
  # complete
  # diagnostic
  # exec
  # global
  # help
  # hooks
  # init
  # local
  # man
  # prefix
  # prefs
  # rehash
  # root
  # shims
  # rehash
  # shell
  # version
  # version-jlenv
  # versions
  # whence
  # which
}

# in the test enviornment we use libenv-echo.
# make sure this doesn't leak into the list jlenv2 
# commands
@test "commands are parsed from libexec contents" {
  run jlenv2 commands
  assert_success
  refute_line "echo"
}

@test "commands -s" {
  run jlenv2 commands -s
  assert_success
  refute_line "init"
  assert_line "shell"
}

@test "commands -g" {
  run jlenv2 commands -g
  assert_success
  assert_line "init"
  refute_line "shell"
}
