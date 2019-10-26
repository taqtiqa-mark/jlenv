#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

@test "no shell version" {
  mkdir -p "${JLENV_TEST_DIR}/myproject"
  cd "${JLENV_TEST_DIR}/myproject"
  echo "1.2.3" > .julia-version
  JLENV_VERSION="" run jlenv2 sh-shell
  assert_failure 
  assert_output "jlenv: no shell-specific version configured"
}

@test "shell version" {
  JLENV_SHELL=bash JLENV_VERSION="1.2.3" run jlenv2 sh-shell
  assert_success 'echo "$JLENV_VERSION"'
}

@test "shell version (fish)" {
  JLENV_SHELL=fish JLENV_VERSION="1.2.3" run jlenv2 sh-shell
  assert_success 'echo "$JLENV_VERSION"'
}

@test "shell revert" {
  JLENV_SHELL=bash run jlenv2 sh-shell -
  assert_success
  assert_line --index 0 'if [ -n "${JLENV_VERSION_OLD+x}" ]; then'
}

@test "shell revert (fish)" {
  JLENV_SHELL=fish run jlenv2 sh-shell -
  assert_success
  assert_line --index 0 'if set -q JLENV_VERSION_OLD'
}

@test "shell unset" {
  JLENV_SHELL=bash run jlenv2 sh-shell --unset
  assert_success
  assert_output --stdin <<'OUT'
JLENV_VERSION_OLD="$JLENV_VERSION"
unset JLENV_VERSION
OUT
}

@test "shell unset (fish)" {
  JLENV_SHELL=fish run jlenv2 sh-shell --unset
  assert_success
  assert_output --stdin <<'OUT'
set -gu JLENV_VERSION_OLD "$JLENV_VERSION"
set -e JLENV_VERSION
OUT
}

@test "shell change invalid version" {
  run jlenv2 sh-shell 1.2.3
  assert_failure
  assert_output --stdin <<'SH'
jlenv: version 'v1.2.3' not installed
false
SH
}

@test "shell change version" {
  mkdir -p "${JLENV_ROOT}/versions/1.2.3"
  JLENV_SHELL=bash run jlenv2 sh-shell 1.2.3
  assert_success
  assert_output --stdin <<'OUT'
JLENV_VERSION_OLD="$JLENV_VERSION"
export JLENV_VERSION="1.2.3"
OUT
}

@test "shell change version (fish)" {
  mkdir -p "${JLENV_ROOT}/versions/1.2.3"
  JLENV_SHELL=fish run jlenv2 sh-shell 1.2.3
  assert_success
  assert_output --stdin <<'OUT'
set -gu JLENV_VERSION_OLD "$JLENV_VERSION"
set -gx JLENV_VERSION "1.2.3"
OUT
}
