#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

@test "help invocation" {
  run jlenv --help
  assert_success
  assert_line --index 0 "$(jlenv---version)"
  assert_output --partial --stdin <<'OUT'
Options to jlenv:
     -h|--help                  Displays this help
     -v|--verbose               Displays verbose output
    -nc|--no-colo(u)r           Disables colour output
    -cr|--cron                  Run silently unless we encounter an error

Usage: jlenv [<opts>] <command> [<args>]

Some useful jlenv commands are:
   commands    List all available jlenv commands
   local       Set or show the local application-specific Julia version
   global      Set or show the global Julia version
   shell       Set or show the shell-specific Julia version
   install     Fake install program
   uninstall   Fake uninstall program
   rehash      Rehash jlenv shims (run this after installing executables)
   version     Show the current Julia version and its origin
   versions    List all Julia versions available to jlenv
   which       Display the full path to an executable
   whence      List all Julia versions that contain the given executable

See $(jlenv help <command>) for information on a specific command.
For full documentation, see: https://github.com/jlenv/jlenv#readme

OUT
}

@test "blank invocation" {
  run jlenv
  assert_failure
assert_line --index 0 "$(jlenv---version)"
  assert_output --partial --stdin <<'OUT'
Options to jlenv:
     -h|--help                  Displays this help
     -v|--verbose               Displays verbose output
    -nc|--no-colo(u)r           Disables colour output
    -cr|--cron                  Run silently unless we encounter an error

Usage: jlenv [<opts>] <command> [<args>]

Some useful jlenv commands are:
   commands    List all available jlenv commands
   local       Set or show the local application-specific Julia version
   global      Set or show the global Julia version
   shell       Set or show the shell-specific Julia version
   install     Fake install program
   uninstall   Fake uninstall program
   rehash      Rehash jlenv shims (run this after installing executables)
   version     Show the current Julia version and its origin
   versions    List all Julia versions available to jlenv
   which       Display the full path to an executable
   whence      List all Julia versions that contain the given executable

See $(jlenv help <command>) for information on a specific command.
For full documentation, see: https://github.com/jlenv/jlenv#readme

OUT
}

@test "invalid command" {
  run jlenv does-not-exist
  assert_failure
  assert_output --partial --stdin <<'OUT'
jlenv:  No such command: $(does-not-exist)
OUT
}

@test "default JLENV_ROOT when inherited as empty string" {
  JLENV_ROOT="" HOME=/home/mislav run jlenv root
  assert_success
  assert_output '/home/mislav/.jlenv'
}

@test "default JLENV_ROOT when inherited as null" {
  JLENV_ROOT= HOME=/home/mislav run jlenv root
  assert_success
  assert_output '/home/mislav/.jlenv'
}

@test "inherited JLENV_ROOT" {
  JLENV_ROOT=/opt/jlenv run jlenv root
  assert_success
  assert_output "/opt/jlenv"
}

@test "default JLENV_DIR" {
  run jlenv echo JLENV_DIR
  assert_output "$(pwd)"
}

@test "inherited JLENV_DIR" {
  dir="${BATS_TMPDIR}/myproject"
  mkdir -p "$dir"
  JLENV_DIR="$dir" run jlenv echo JLENV_DIR
  assert_output "${dir}"
}

@test "invalid JLENV_DIR" {
  dir="${BATS_TMPDIR}/does-not-exist"
  assert [ ! -d "$dir" ]
  JLENV_DIR="$dir" run jlenv echo JLENV_DIR
  assert_failure
  assert_output --partial --stdin <<OUT
jlenv:  Cannot change working directory to \$(${dir})
OUT
}

@test "adds its own libexec to PATH" {
  run jlenv echo "PATH"
  assert_success "${BATS_TEST_DIRNAME%/*}/libexec:$PATH"
}

@test "adds plugin bin dirs to PATH" {
  mkdir -p "$JLENV_ROOT"/plugins/julia-build/bin
  mkdir -p "$JLENV_ROOT"/plugins/jlenv-each/bin
  run jlenv echo -F: "PATH"
  assert_success
  assert_line --index 0 "${BATS_TEST_DIRNAME%/*}/libexec"
  assert_line --index 1 "${JLENV_ROOT}/plugins/julia-build/bin"
  assert_line --index 2 "${JLENV_ROOT}/plugins/jlenv-each/bin"
}

@test "JLENV_HOOK_PATH preserves value from environment" {
  JLENV_HOOK_PATH=/my/hook/path:/other/hooks run jlenv echo -F: "JLENV_HOOK_PATH"
  assert_success
  assert_line --index 0 "/my/hook/path"
  assert_line --index 1 "/other/hooks"
  assert_line --index 2 "${JLENV_ROOT}/jlenv.d"
}

@test "JLENV_HOOK_PATH includes jlenv built-in plugins" {
  unset JLENV_HOOK_PATH
  run jlenv echo "JLENV_HOOK_PATH"
  assert_success "${JLENV_ROOT}/jlenv.d:${BATS_TEST_DIRNAME%/*}/jlenv.d:/usr/local/etc/jlenv.d:/etc/jlenv.d:/usr/lib/jlenv/hooks"
}
