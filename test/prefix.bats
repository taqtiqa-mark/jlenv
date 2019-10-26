#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

@test "prefix" {
  mkdir -p "${JLENV_TEST_DIR}/myproject"
  cd "${JLENV_TEST_DIR}/myproject"
  echo "1.2.3" > .julia-version
  mkdir -p "${JLENV_ROOT}/versions/1.2.3"
  run jlenv2 prefix
  assert_success 
  assert_output "${JLENV_ROOT}/versions/1.2.3"
}

@test "prefix for invalid version" {
  JLENV_VERSION="1.2.3" run jlenv2 prefix
  assert_failure 
  assert_output "jlenv: version 'v1.2.3' not installed"
}

@test "prefix for system" {
  mkdir -p "${JLENV_TEST_DIR}/bin"
  touch "${JLENV_TEST_DIR}/bin/julia"
  chmod +x "${JLENV_TEST_DIR}/bin/julia"
  JLENV_VERSION="system" run jlenv2 prefix
  assert_success 
  assert_output "$JLENV_TEST_DIR"
}

# NOTE: In making jlenv more robust it is now not possible 
# to hijack PATH or a function and insert the test dummy jlenv-which in
# the manner done by the test after this. 

# @test "prefix for system in /" {
#   PATH="${BATS_TEST_DIRNAME}/libexec:${BATS_TEST_DIRNAME}/../libexec:/usr/bin:/bin:/usr/local/bin"
#   mkdir -p "${BATS_TEST_DIRNAME}/libexec"
#   cat >"${BATS_TEST_DIRNAME}/libexec/jlenv-which" <<OUT
# #!/bin/sh
# echo /bin/julia
# OUT
#   chmod +x "${BATS_TEST_DIRNAME}/libexec/jlenv-which"
#   PATH=${PATH} JLENV_VERSION="system" run jlenv2 prefix
#   assert_success 
#   assert_output "/"
#   rm -f "${BATS_TEST_DIRNAME}/libexec/jlenv-which"
# }

@test "cannot hijack system installation by script function" {
  function jlenv-which() {
  echo /bad/user/hijacked/bin/julia
  }
  export -f jlenv-which
  JLENV_VERSION="system" run jlenv2 prefix
  refute_output "/bad/user/hijacked"
}

@test "cannot hijack system installation by \${PATH}" {
  PATH="${BATS_TEST_DIRNAME}/libexec:${BATS_TEST_DIRNAME}/../libexec:/usr/bin:/bin:/usr/local/bin"
  mkdir -p "${BATS_TEST_DIRNAME}/libexec"
  cat >"${BATS_TEST_DIRNAME}/libexec/jlenv-which" <<OUT
#!/bin/sh
echo /bad/user/hijacked/bin/julia
OUT
  chmod +x "${BATS_TEST_DIRNAME}/libexec/jlenv-which"
  PATH=${PATH} JLENV_VERSION="system" run jlenv2 prefix
  refute_output "/bad/user/hijacked"
  rm -f "${BATS_TEST_DIRNAME}/libexec/jlenv-which"
}

@test "prefix for invalid system" {
  PATH="$(path_without julia)" run jlenv2 prefix system
  assert_failure 
  assert_output "jlenv: system version not found in PATH"
}
