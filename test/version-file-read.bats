#!/usr/bin/env bats

load test_helper

setup() {
  mkdir -p "${JLENV_TEST_DIR}/myproject"
  cd "${JLENV_TEST_DIR}/myproject"
}

@test "fails without arguments" {
  run jlenv-version-file-read
  assert_failure ""
}

@test "fails for invalid file" {
  run jlenv-version-file-read "non-existent"
  assert_failure ""
}

@test "fails for blank file" {
  echo > my-version
  run jlenv-version-file-read my-version
  assert_failure ""
}

@test "reads simple version file" {
  cat > my-version <<<"1.0.3"
  run jlenv-version-file-read my-version
  assert_success "1.0.3"
}

@test "ignores leading spaces" {
  cat > my-version <<<"  1.0.3"
  run jlenv-version-file-read my-version
  assert_success "1.0.3"
}

@test "reads only the first word from file" {
  cat > my-version <<<"1.0.3-p194@tag 0.7.0 hi"
  run jlenv-version-file-read my-version
  assert_success "1.0.3-p194@tag"
}

@test "loads only the first line in file" {
  cat > my-version <<IN
0.7.0 one
1.0.3 two
IN
  run jlenv-version-file-read my-version
  assert_success "0.7.0"
}

@test "ignores leading blank lines" {
  cat > my-version <<IN

1.0.3
IN
  run jlenv-version-file-read my-version
  assert_success "1.0.3"
}

@test "handles the file with no trailing newline" {
  echo -n "0.7.0" > my-version
  run jlenv-version-file-read my-version
  assert_success "0.7.0"
}

@test "ignores carriage returns" {
  cat > my-version <<< $'1.0.3\r'
  run jlenv-version-file-read my-version
  assert_success "1.0.3"
}
