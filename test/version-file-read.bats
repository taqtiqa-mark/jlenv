#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

setup() {
  mkdir -p "${JLENV_TEST_DIR}/myproject"
  cd "${JLENV_TEST_DIR}/myproject"
}

@test "fails without arguments" {
  run jlenv2 version-file-read
  assert_failure
  assert_output --stdin <<OUT
jlenv2: version-file-read
jlenv2: need at least 1 args, 0 given: invalid number of arguments
OUT
}

@test "fails with more than one argument" {
  run jlenv2 version-file-read a b
  assert_failure
  assert_output --stdin <<OUT
jlenv2: version-file-read
jlenv2: need at most 1 args, 2 given: invalid number of arguments
OUT
}

@test "fails for invalid file" {
  run jlenv2 version-file-read "non-existent"
  assert_failure
  assert_output --stdin <<OUT
jlenv2: The file non-existent does not exist.: No Julia version file (.julia-version) found.
OUT
}

@test "fails for blank file" {
  echo > my-version
  run jlenv2 version-file-read my-version
  assert_failure
  assert_output --stdin <<OUT
jlenv2: The file my-version contained: <start><end>.: No Julia version read from .julia-version.
OUT
}

@test "reads simple version file" {
  cat > my-version <<<"1.0.3"
  run jlenv2 version-file-read my-version
  assert_success "1.0.3"
}

@test "ignores leading spaces" {
  cat > my-version <<<"  1.0.3"
  run jlenv2 version-file-read my-version
  assert_success "1.0.3"
}

@test "reads only the first word from file" {
  cat > my-version <<<"1.0.3-p194@tag 0.7.0 hi"
  run jlenv2 version-file-read my-version
  assert_success "1.0.3-p194@tag"
}

@test "loads only the first line in file" {
  cat > my-version <<IN
0.7.0 one
1.0.3 two
IN
  run jlenv2 version-file-read my-version
  assert_success "0.7.0"
}

@test "ignores leading blank lines" {
  cat > my-version <<IN

1.0.3
IN
  run jlenv2 version-file-read my-version
  assert_success "1.0.3"
}

@test "handles the file with no trailing newline" {
  echo -n "0.7.0" > my-version
  run jlenv2 version-file-read my-version
  assert_success "0.7.0"
}

@test "ignores carriage returns" {
  cat > my-version <<< $'1.0.3\r'
  run jlenv2 version-file-read my-version
  assert_success "1.0.3"
}
