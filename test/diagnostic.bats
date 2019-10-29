#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

create_version() {
  mkdir -p "${JLENV_ROOT}/versions/$1"
}

setup() {
  mkdir -p "$JLENV_TEST_DIR"
  cd "$JLENV_TEST_DIR"
}

@test "default JLENV_DIR" {
  run jlenv2 diagnostic
  assert_output "$(pwd)"
}

@test "inherited JLENV_DIR" {
  dir="${BATS_TMPDIR}/myproject"
  mkdir -p "$dir"
  JLENV_DIR="$dir" run jlenv2 diagnostic
  assert_output "${dir}"
}
