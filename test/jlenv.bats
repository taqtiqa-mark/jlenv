#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

# The help for each command is tested in the <command>.bats file.
@test "help invocation" {
  run jlenv2 help
  assert_success
  assert_line --index 0 "### jlenv2 -- Robust Julia version management. ###"
}

@test "blank invocation" {
  run jlenv2
  assert_failure
  assert_line --index 0 "# Usage: jlenv2 command [options]"
  assert_line --index 1 "Available commands:"
}

@test "only known commands are made available" {
  run jlenv2 commands
  assert_success
  assert_output --partial --stdin <<'OUT'
commands
complete
exec
diagnostic
global
help
hooks
init
local
man
prefix
prefs
rehash
root
shims
rehash
shell
version
version-file
version-file-read
version-file-write
version-jlenv
version-name
version-origin
versions
whence
which
OUT
}

@test "invalid command" {
  run jlenv2 does-not-exist
  assert_failure
  assert_output --partial --stdin <<'OUT'
jlenv2: does-not-exist: invalid command
Available commands:
OUT
}

# This echo command used to work.  It was used to check env variables.
# Now we use the jlenv2 diagnostic subcommand
@test "Cannot inject a command by dropping scripts in libexec" {
  run jlenv2 echo JLENV_DIR
  assert_output --partial --stdin <<OUT
jlenv2: echo: invalid command
Available commands:
OUT
}

@test "default JLENV_DIR" {
  run jlenv2 echo JLENV_DIR
  assert_output "$(pwd)"
}

@test "inherited JLENV_DIR" {
  dir="${BATS_TMPDIR}/myproject"
  mkdir -p "$dir"
  JLENV_DIR="$dir" run jlenv2 echo JLENV_DIR
  assert_output "${dir}"
}

@test "invalid JLENV_DIR" {
  dir="${BATS_TMPDIR}/does-not-exist"
  assert [ ! -d "$dir" ]
  JLENV_DIR="$dir" run jlenv2 echo JLENV_DIR
  assert_failure
  assert_output --partial --stdin <<OUT
jlenv:  Cannot change working directory to \$(${dir})
OUT
}

@test "adds its own libexec to PATH" {
  run jlenv2 echo "PATH"
  assert_success 
  assert_output "${BATS_TEST_DIRNAME%/*}/libexec:$PATH"
}

@test "adds plugin bin dirs to PATH" {
  mkdir -p "$JLENV_ROOT"/plugins/julia-build/bin
  mkdir -p "$JLENV_ROOT"/plugins/jlenv-each/bin
  run jlenv2 echo -F: "PATH"
  assert_success
  assert_line --index 0 "${BATS_TEST_DIRNAME%/*}/libexec"
  assert_line --index 1 "${JLENV_ROOT}/plugins/julia-build/bin"
  assert_line --index 2 "${JLENV_ROOT}/plugins/jlenv-each/bin"
}

@test "JLENV_HOOK_PATH preserves value from environment" {
  JLENV_HOOK_PATH=/my/hook/path:/other/hooks run jlenv2 echo -F: "JLENV_HOOK_PATH"
  assert_success
  assert_line --index 0 "/my/hook/path"
  assert_line --index 1 "/other/hooks"
  assert_line --index 2 "${JLENV_ROOT}/jlenv.d"
}

@test "JLENV_HOOK_PATH includes jlenv2 built-in plugins" {
  unset JLENV_HOOK_PATH
  run jlenv2 echo "JLENV_HOOK_PATH"
  assert_success 
  assert_output "${JLENV_ROOT}/jlenv.d:${BATS_TEST_DIRNAME%/*}/jlenv.d:/usr/local/etc/jlenv.d:/etc/jlenv.d:/usr/lib/jlenv/hooks"
}
