#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

@test "default" {
  run jlenv2 global
  assert_success
  assert_output "system"
}

@test "read JLENV_ROOT/version" {
  mkdir -p "$JLENV_ROOT"
  echo "1.2.3" > "$JLENV_ROOT/version"
  run jlenv2 global
  assert_success
  assert_output "1.2.3"
}

@test "set JLENV_ROOT/version" {
  mkdir -p "$JLENV_ROOT/versions/1.2.3"
  run jlenv2 global "1.2.3"
  assert_success
  run jlenv2 global
  assert_success 
  assert_output "1.2.3"
}

@test "fail setting invalid JLENV_ROOT/version" {
  mkdir -p "$JLENV_ROOT"
  run jlenv2 global "1.2.3"
  assert_failure 
  assert_output "jlenv: version 'v1.2.3' not installed"
}
