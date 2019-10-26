#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

setup() {
  mkdir -p "${JLENV_TEST_DIR}/myproject"
  cd "${JLENV_TEST_DIR}/myproject"
}

@test "no version" {
  assert [ ! -e "${PWD}/.julia-version" ]
  run jlenv2 local
  assert_failure 
  assert_line --index 0 "jlenv: no local version configured for this directory"
  assert_line --index 1 "jlenv2: Searched: /.julia-version ... /.julia-version: No Julia version file (.julia-version) found."
}

@test "local version" {
  echo "1.2.3" > .julia-version
  run jlenv2 local
  assert_success 
  assert_output "1.2.3"
}

@test "discovers version file in parent directory" {
  echo "1.2.3" > .julia-version
  mkdir -p "subdir" && cd "subdir"
  run jlenv2 local
  assert_success 
  assert_output "1.2.3"
}

@test "ignores JLENV_DIR" {
  echo "1.2.3" > .julia-version
  mkdir -p "$HOME"
  echo "2.0-home" > "${HOME}/.julia-version"
  JLENV_DIR="$HOME" run jlenv2 local
  assert_success 
  assert_output "1.2.3"
}

@test "sets local version" {
  mkdir -p "${JLENV_ROOT}/versions/1.2.3"
  run jlenv2 local 1.2.3
  assert_success
  assert_output ""
  run jlenv2 local
  assert_success 
  assert_output "1.2.3"
}

@test "changes local version" {
  echo "1.0-pre" > .julia-version
  mkdir -p "${JLENV_ROOT}/versions/1.2.3"
  run jlenv2 local
  assert_success 
  assert_output "1.0-pre"
  run jlenv2 local 1.2.3
  assert_success
  assert_output ""
  run jlenv2 local
  assert_success 
  assert_output "1.2.3"

}

@test "unsets local version" {
  touch .julia-version
  run jlenv2 local --unset
  assert_success 
  assert_output ""
  assert [ ! -e .julia-version ]
}
