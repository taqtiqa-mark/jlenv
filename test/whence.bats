#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

create_executable() {
  local bin="${JLENV_ROOT}/versions/${1}/bin"
  mkdir -p "$bin"
  touch "${bin}/$2"
  chmod +x "${bin}/$2"
}

@test "finds versions where present" {
  create_executable "0.7" "julia"
  create_executable "1.0" "juliac"
  create_executable "2.0" "julia"
  create_executable "2.0" "juliac"
  create_executable "1.0" "genie"

  run jlenv2 whence julia
  assert_success
  assert_output --stdin <<OUT
0.7
2.0
OUT

  run jlenv2 whence juliac
  assert_success
  assert_output --stdin <<OUT
1.0
2.0
OUT

  run jlenv2 whence genie
  assert_success "1.0"
}

@test "finds versions where present, and shows paths" {
  create_executable "0.7" "julia"
  create_executable "1.0" "juliac"
  create_executable "2.0" "julia"
  create_executable "2.0" "juliac"
  create_executable "1.0" "genie"

  run jlenv2 whence --path julia
  assert_success
  assert_output --stdin <<OUT
${JLENV_TEST_DIR}/root/versions/0.7/bin/julia
${JLENV_TEST_DIR}/root/versions/2.0/bin/julia
OUT

  run jlenv2 whence --path juliac
  assert_success
  assert_output --stdin <<OUT
${JLENV_TEST_DIR}/root/versions/1.0/bin/juliac
${JLENV_TEST_DIR}/root/versions/2.0/bin/juliac
OUT

  run jlenv2 whence --path genie
  assert_success "/tmp/jlenv.9cy/root/versions/1.0/bin/genie"
}