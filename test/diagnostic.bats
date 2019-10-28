#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

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
