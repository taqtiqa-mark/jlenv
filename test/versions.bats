#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

create_version() {
  mkdir -p "${JLENV_ROOT}/versions/$1"
}

setup() {
  mkdir -p "${JLENV_TEST_DIR}"
  cd "${JLENV_TEST_DIR}"
}

stub_system_julia() {
  local stub="${JLENV_TEST_DIR}/bin/julia"
  mkdir -p "$(dirname "$stub")"
  touch "$stub" && chmod +x "$stub"
}

@test "no versions installed" {
  stub_system_julia
  assert [ ! -d "${JLENV_ROOT}/versions" ]
  run jlenv-versions
  assert_success 
  assert_line --index 0 "* system (set by ${JLENV_TEST_DIR}/root/version)"
}

@test "not even system julia available" {
  PATH="$(path_without julia)" run jlenv-versions
  assert_failure
  assert_output "Warning: no Julia detected on the system"
}

@test "bare output no versions installed" {
  assert [ ! -d "${JLENV_ROOT}/versions" ]
  run jlenv-versions --bare
  assert_success ""
}

@test "single version installed" {
  stub_system_julia
  create_version "1.9"
  run jlenv-versions
  assert_success
  assert_line --index 0 "* system (set by ${JLENV_TEST_DIR}/root/version)"
  assert_output --partial '1.9'
}

@test "single version bare" {
  create_version "1.9"
  run jlenv-versions --bare
  assert_success "1.9"
}

@test "multiple versions" {
  stub_system_julia
  create_version "0.7.0"
  create_version "1.0.3"
  create_version "2.0.0"
  run jlenv-versions
  assert_success
  assert_output <<OUT
* system (set by ${JLENV_ROOT}/version)
  0.7.0
  1.0.3
  2.0.0
OUT
}

@test "indicates current version" {
  stub_system_julia
  create_version "1.0.3"
  create_version "2.0.0"
  JLENV_VERSION=1.0.3 run jlenv-versions
  assert_success
  assert_line --index 0 '  system'
  assert_line --index 1 '* 1.0.3 (set by JLENV_VERSION environment variable)'
  assert_line --index 2 '  2.0.0'
  assert_output --stdin <<'OUT'
  system
* 1.0.3 (set by JLENV_VERSION environment variable)
  2.0.0
OUT
}

@test "bare doesn't indicate current version" {
  create_version "1.0.3"
  create_version "2.0.0"
  JLENV_VERSION=1.0.3 run jlenv-versions --bare
  assert_success
  assert_output <<OUT
1.0.3
2.0.0
OUT
}

@test "globally selected version" {
  stub_system_julia
  create_version "1.0.3"
  create_version "2.0.0"
  cat > "${JLENV_ROOT}/version" <<<"1.0.3"
  run jlenv-versions
  assert_success
  assert_output <<OUT
  system
* 1.0.3 (set by ${JLENV_ROOT}/version)
  2.0.0
OUT
}

@test "per-project version" {
  stub_system_julia
  create_version "1.0.3"
  create_version "2.0.0"
  cat > ".julia-version" <<<"1.0.3"
  run jlenv-versions
  assert_success
  assert_output <<OUT
  system
* 1.0.3 (set by ${JLENV_TEST_DIR}/.julia-version)
  2.0.0
OUT
}

@test "ignores non-directories under versions" {
  create_version "1.9"
  touch "${JLENV_ROOT}/versions/hello"

  run jlenv-versions --bare
  assert_success "1.9"
}

@test "lists symlinks under versions" {
  create_version "0.7.0"
  ln -s "0.7.0" "${JLENV_ROOT}/versions/0.7"

  run jlenv-versions --bare
  assert_success
  assert_output <<OUT
0.7
0.7.0
OUT
}

@test "doesn't list symlink aliases when --skip-aliases" {
  create_version "0.7.0"
  ln -s "0.7.0" "${JLENV_ROOT}/versions/0.7"
  mkdir moo
  ln -s "${PWD}/moo" "${JLENV_ROOT}/versions/1.9"

  run jlenv-versions --bare --skip-aliases
  assert_success

  assert_output <<OUT
0.7.0
1.9
OUT
}
