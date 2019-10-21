#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

create_executable() {
  name="${1?}"
  shift 1
  bin="${JLENV_ROOT}/versions/${JLENV_VERSION}/bin"
  mkdir -p "$bin"
  { if [ $# -eq 0 ]; then cat -
    else echo "$@"
    fi
  } | sed -Ee '1s/^ +//' > "${bin}/$name"
  chmod +x "${bin}/$name"
}

@test "fails with invalid version" {
  export JLENV_VERSION="2.0"
  run jlenv-exec julia -v
  assert_failure "jlenv: version 'v2.0' is not installed (set by JLENV_VERSION environment variable)"
}

@test "fails with invalid version set from file" {
  mkdir -p "$JLENV_TEST_DIR"
  cd "$JLENV_TEST_DIR"
  echo 1.9 > .julia-version
  run jlenv-exec juliac
  assert_failure "jlenv: version \`1.9' is not installed (set by $PWD/.julia-version)"
}

@test "completes with names of executables" {
  export JLENV_VERSION="2.0"
  create_executable "julia" "#!/bin/sh"

  jlenv-rehash
  run jlenv-completions exec
  assert_success
  assert_output --stdin <<'OUT'
--help
julia
OUT
}

@test "carries original IFS within hooks" {
  create_hook exec hello.bash <<SH
hellos=(\$(printf "hello\\tugly world\\nagain"))
echo HELLO="\$(printf ":%s" "\${hellos[@]}")"
SH

  export JLENV_VERSION=system
  IFS=$' \t\n' run jlenv-exec env
  assert_success
  assert_line "HELLO=:hello:ugly:world:again"
}

@test "forwards all arguments" {
  export JLENV_VERSION="2.0"
  create_executable "julia" <<SH
#!$BASH
echo \$0
for arg; do
  # hack to avoid bash builtin echo which can't output '-e'
  printf "  %s\\n" "\$arg"
done
SH

  run jlenv-exec julia -w "/path to/julia script.rb" -- extra args
  assert_success
  assert_line --index 0 --regexp '(jlenv\.[a-zA-Z0-9]{3})/(root/versions/2\.0/bin/julia)'
  assert_output --partial --stdin <<'OUT'
  -w
  /path to/julia script.rb
  --
  extra
  args
OUT
}
