#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

@test "without args shows summary of common commands" {
  run jlenv-help
  assert_success
  assert_line "Usage: jlenv [<opts>] <command> [<args>]"
  assert_line "Some useful jlenv commands are:"
}

@test "invalid command" {
  run jlenv-help hello
  assert_failure "jlenv: no such command \$(hello)"
}

@test "shows help for a specific command" {
  mkdir -p "${JLENV_TEST_DIR}/bin"
  cat > "${JLENV_TEST_DIR}/bin/jlenv-hello" <<SH
#!shebang
# Usage: jlenv hello <world>
# Summary: Says "hello" to you, from jlenv
# This command is useful for saying hello.
echo hello
SH

# workaround issue with bats-assert rejects matching strings.
  run jlenv-help hello
  assert_success
#   assert_output --partial --stdin <<SH
# Usage: jlenv hello <world>

# This command is useful for saying hello.
# SH
  expect=$(cat <<SH
Usage: jlenv hello <world>

This command is useful for saying hello.
SH
)
result="$(git -c color.diff=always diff --no-patch --ws-error-highlight=new,old $(echo "$output" | tail +2 | git hash-object -w --stdin) $(echo "$expect"| git hash-object -w --stdin))"
[ "${result}" = "" ]
}

# workaround issue with bats-assert rejects matching strings.
@test "replaces missing extended help with summary text" {
  mkdir -p "${JLENV_TEST_DIR}/bin"
  cat > "${JLENV_TEST_DIR}/bin/jlenv-hello" <<SH
#!shebang
# Usage: jlenv hello <world>
# Summary: Says "hello" to you, from jlenv
echo hello
SH

  run jlenv-help hello
  assert_success
#   assert_output --stdin <<'SH'
# Usage: jlenv hello <world>

# Says "hello" to you, from jlenv
# SH
expect=$(cat <<SH
Usage: jlenv hello <world>

Says "hello" to you, from jlenv
SH
)
result="$(git -c color.diff=always diff --no-patch --ws-error-highlight=new,old $(echo "$output" | git hash-object -w --stdin) $(echo "$expect"| git hash-object -w --stdin))"
[ "${result}" = "" ]
}

@test "extracts only usage" {
  mkdir -p "${JLENV_TEST_DIR}/bin"
  cat > "${JLENV_TEST_DIR}/bin/jlenv-hello" <<SH
#!shebang
# Usage: jlenv hello <world>
# Summary: Says "hello" to you, from jlenv
# This extended help won't be shown.
echo hello
SH

  run jlenv-help --usage hello
  assert_success "Usage: jlenv hello <world>"
}

# workaround issue with bats-assert rejects matching strings.
@test "multiline usage section" {
  mkdir -p "${JLENV_TEST_DIR}/bin"
  cat > "${JLENV_TEST_DIR}/bin/jlenv-hello" <<SH
#!shebang
# Usage: jlenv hello <world>
#        jlenv hi [everybody]
#        jlenv hola --translate
# Summary: Says "hello" to you, from jlenv
# Help text.

echo hello
SH

  run jlenv-help hello
  assert_success
#   assert_output --stdin <<'SH'
# Usage: jlenv hello <world>
#        jlenv hi [everybody]
#        jlenv hola --translate

# Help text.
# SH
  # assert_output ""
expect=$(cat <<SH
Usage: jlenv hello <world>
       jlenv hi [everybody]
       jlenv hola --translate

Help text.
SH
)
result="$(git -c color.diff=always diff --shortstat $(echo "$output" | tail +2| git hash-object -w --stdin) $(echo "$expect"| git hash-object -w --stdin))"
echo $?
echo ${result}
result="$(git -c color.diff=always diff --color --word-diff-regex=. $(echo "$output" | tail +2| git hash-object -w --stdin) $(echo "$expect"| git hash-object -w --stdin))"
echo $?
echo ${result}
assert_output "${result}"
[ "${result}" = "" ]
}

# workaround issue with bats-assert rejects matching strings.
@test "multiline extended help section" {
  mkdir -p "${JLENV_TEST_DIR}/bin"
  cat > "${JLENV_TEST_DIR}/bin/jlenv-hello" <<SH
#!shebang
#
# Summary: Says "hello" to you, from jlenv
#
# Usage: jlenv hello <world>
#
# This is extended help text.
# It can contain multiple lines.
#
# And paragraphs.

echo hello
SH

  run jlenv-help hello
  assert_success
#   assert_output --stdin <<'SH'
# Usage: jlenv hello <world>

# This is extended help text.
# It can contain multiple lines.

# And paragraphs.
# SH
expect=$(cat <<SH
Usage: jlenv hello <world>

This is extended help text.
It can contain multiple lines.

And paragraphs.
SH
)
result="$(git -c color.diff=always diff --no-patch --ws-error-highlight=new,old $(echo "$output" | git hash-object -w --stdin) $(echo "$expect"| git hash-object -w --stdin))"
[ "${result}" = "" ]
}
