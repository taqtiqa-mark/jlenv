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

@test "no version selected" {
  assert [ ! -d "${JLENV_ROOT}/versions" ]
  run jlenv-version
  assert_success 
  assert_output "system (set by ${JLENV_ROOT}/version)"
}

@test "set by JLENV_VERSION" {
  create_version "1.0.3"
  JLENV_VERSION=1.0.3 run jlenv-version
  assert_success 
  assert_output "1.0.3 (set by JLENV_VERSION environment variable)"
}

@test "set by local file" {
  create_version "1.0.3"
  cat > ".julia-version" <<<"1.0.3"
  run jlenv-version
  assert_success "1.0.3 (set by ${PWD}/.julia-version)"
}

@test "set by global file" {
  create_version "1.0.3"
  cat > "${JLENV_ROOT}/version" <<<"1.0.3"
  run jlenv-version
  assert_success "1.0.3 (set by ${JLENV_ROOT}/version)"
}
