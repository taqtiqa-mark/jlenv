#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

@test "without args shows summary of common commands" {
  run jlenv2 help
  assert_success
  assert_line --index 0 "### jlenv2 -- Robust Julia version management. ###"
  assert_line --index 1 "# Usage: jlenv2 command [options]"
}

@test "invalid command passed to help returns a list of valid commands" {
  run jlenv2 help hello
  assert_failure
  assert_line --index 0 "Available commands:"
}

@test "shows help for a specific command" {
  mkdir -p "${JLENV_TEST_DIR}/bin"
  cat > "${JLENV_TEST_DIR}/bin/jlenv-hello" <<SH
#!shebang
# Usage: jlenv hello <world>
# Summary: Says "hello" to you, from jlenv
# This command is useful for saying hello.
echo hello
SH

# workaround issue with bats-assert rejects matching strings.
  run jlenv2 help help
  assert_success
  assert_output --partial --stdin <<OUT
Print online help.

Usage: help [command]

Without arguments, print the list of available commands. Otherwise,
print the help text for the given command.
OUT
}
