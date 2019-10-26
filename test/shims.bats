#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

@test "no shims" {
  run jlenv2 shims
  assert_success
  assert [ -z "$output" ]
}

@test "shims" {
  mkdir -p "${JLENV_ROOT}/shims"
  touch "${JLENV_ROOT}/shims/julia"
  touch "${JLENV_ROOT}/shims/genie"
  run jlenv2 shims
  assert_success
  assert_line "${JLENV_ROOT}/shims/julia"
  assert_line "${JLENV_ROOT}/shims/genie"
}

@test "shims --short" {
  mkdir -p "${JLENV_ROOT}/shims"
  touch "${JLENV_ROOT}/shims/julia"
  touch "${JLENV_ROOT}/shims/genie"
  run jlenv2 shims --short
  assert_success
  assert_line "genie"
  assert_line "julia"
}
