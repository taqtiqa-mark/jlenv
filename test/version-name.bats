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
  run jlenv2 version-name
  assert_success "system"
}

@test "system version is not checked for existance" {
  JLENV_VERSION=system run jlenv2 version-name
  assert_success "system"
}

@test "JLENV_VERSION can be overridden by hook" {
  create_version "0.7.0"
  create_version "1.0.3"
  create_hook version-name test.bash <<<"JLENV_VERSION=1.0.3"

  JLENV_VERSION=0.7.0 run jlenv2 version-name
  assert_success "1.0.3"
}

@test "carries original IFS within hooks" {
  create_hook version-name hello.bash <<SH
hellos=(\$(printf "hello\\tugly world\\nagain"))
echo HELLO="\$(printf ":%s" "\${hellos[@]}")"
SH

  JLENV_VERSION=system IFS=$' \t\n' run jlenv2 version-name env
  assert_success
  assert_output <<OUT
HELLO=:hello:ugly:world:again"
system
OUT
}

@test "JLENV_VERSION has precedence over local" {
  create_version "0.7.0"
  create_version "1.0.3"

  cat > ".julia-version" <<<"0.7.0"
  run jlenv2 version-name
  assert_success "0.7.0"

  JLENV_VERSION=1.0.3 run jlenv2 version-name
  assert_success "1.0.3"
}

@test "local file has precedence over global" {
  create_version "0.7.0"
  create_version "1.0.3"

  cat > "${JLENV_ROOT}/version" <<<"0.7.0"
  run jlenv2 version-name
  assert_success "0.7.0"

  cat > ".julia-version" <<<"1.0.3"
  run jlenv2 version-name
  assert_success "1.0.3"
}

@test "missing version" {
  JLENV_VERSION=1.2 run jlenv2 version-name
  assert_failure "jlenv: version 'v1.2' is not installed (set by JLENV_VERSION environment variable)"
}

@test "version with prefix in name" {
  create_version "0.7.0"
  cat > ".julia-version" <<<"julia-0.7.0"
  JLENV_VERSION= run jlenv2 version-name
  assert_success
  assert_output "0.7.0"
}
