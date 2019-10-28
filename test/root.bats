#!/usr/bin/env bats

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

@test "default JLENV_ROOT when inherited as empty string" {
  JLENV_ROOT="" HOME=/home/another run jlenv2 root
  assert_success
  assert_output '/home/another/.jlenv'
}

@test "default JLENV_ROOT when inherited as null" {
  JLENV_ROOT= HOME=/home/another run jlenv2 root
  assert_success
  assert_output '/home/another/.jlenv'
}

@test "inherited JLENV_ROOT" {
  JLENV_ROOT=/opt/jlenv run jlenv2 root
  assert_success
  assert_output '/opt/jlenv'
}
