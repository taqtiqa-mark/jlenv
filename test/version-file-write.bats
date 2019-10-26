#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

setup() {
  mkdir -p "$JLENV_TEST_DIR"
  cd "$JLENV_TEST_DIR"
}

@test "invocation without 2 arguments prints usage" {
  run jlenv2 version-file-write
  assert_failure "Usage: jlenv version-file-write <file> <version>"
  run jlenv2 version-file-write "one" ""
  assert_failure
}

@test "setting nonexistent version fails" {
  assert [ ! -e ".julia-version" ]
  run jlenv2 version-file-write ".julia-version" "0.7.0"
  assert_failure "jlenv: version \`0.7.0' not installed"
  assert [ ! -e ".julia-version" ]
}

@test "writes value to arbitrary file" {
  mkdir -p "${JLENV_ROOT}/versions/0.7.0"
  assert [ ! -e "my-version" ]
  run jlenv2 version-file-write "${PWD}/my-version" "0.7.0"
  assert_success ""
  assert [ "$(cat my-version)" = "0.7.0" ]
}
