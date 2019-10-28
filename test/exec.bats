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

@test "fails when version set by environment variable is not installed" {
  export JLENV_VERSION="2.0"
  run jlenv2 exec julia -v
  assert_failure 
  assert_output --stdin <<OUT
jlenv: version 'v2.0' is not installed (set by JLENV_VERSION environment variable)
jlenv2: No Julia version read from JLENV_VERSION, .julia-version.
OUT
}

@test "fails when uninstalled version set from .julia-version file" {
  mkdir -p "$JLENV_TEST_DIR"
  cd "$JLENV_TEST_DIR"
  echo 1.9 > .julia-version
  run jlenv2 exec julia
  assert_failure 
  assert_output --stdin <<OUT
jlenv: version 'v1.9' is not installed (set by $PWD/.julia-version)
jlenv2: No Julia version read from JLENV_VERSION, .julia-version.
OUT
}

# Completions not yet implemented.
# @test "completes with names of executables" {
#   export JLENV_VERSION="2.0"
#   create_executable "julia" "#!/bin/sh"

#   run jlenv2 rehash
#   run jlenv-completions exec
#   assert_success
#   assert_output --stdin <<'OUT'
# --help
# julia
# OUT
# }

@test "carries original IFS within hooks" {
  create_hook exec hello.bash <<SH
hellos=(\$(printf "hello\\tugly world\\nagain"))
echo HELLO="\$(printf ":%s" "\${hellos[@]}")"
SH

  export JLENV_VERSION=system
  IFS=$' \t\n' run jlenv2 exec env
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

  run jlenv2 exec julia -w "/path to/julia script.rb" -- extra args
  assert_success
  assert_line --index 0 "${JLENV_TEST_DIR}/root/versions/2.0/bin/julia"
  assert_output --partial --stdin <<'OUT'
  -w
  /path to/julia script.rb
  --
  extra
  args
OUT
}
