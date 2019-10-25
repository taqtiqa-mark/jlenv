#!/usr/bin/env bats

# See: https://unix.stackexchange.com/questions/125522/path-syntax-rules

load libs/bats-support/load
load libs/bats-assert/load
load test_helper

# @test "relative path . JLENV_ROOT is resolved" {
#   JLENV_ROOT=. run jlenv root
#   assert_success
#   assert_output "/opt/jlenv"
# }

# @test "relative path ./a JLENV_ROOT is resolved" {
#   JLENV_ROOT=./a run jlenv root
#   assert_success
#   assert_output "/opt/jlenv"
# }

# @test "relative path .. for JLENV_ROOT is resolved" {
#   JLENV_ROOT=.. run jlenv root
#   assert_success
#   assert_output "/opt/jlenv"
# }

# @test "relative path ../b for JLENV_ROOT is resolved" {
#   JLENV_ROOT=../b run jlenv root
#   assert_success
#   assert_output "/opt/jlenv"
# }

# @test "relative path ./.. for JLENV_ROOT is resolved" {
#   JLENV_ROOT=./.. run jlenv root
#   assert_success
#   assert_output "/opt/jlenv"
# }

# @test "relative path ./../ for JLENV_ROOT is resolved" {
#   JLENV_ROOT=./../ run jlenv root
#   assert_success
#   assert_output "/opt/jlenv"
# }

# @test "relative path ./../.. for JLENV_ROOT is resolved" {
#   JLENV_ROOT=./../.. run jlenv root
#   assert_success
#   assert_output "/opt/jlenv"
# }

# @test "relative path ./../../ for JLENV_ROOT is resolved" {
#   JLENV_ROOT=./../../ run jlenv root
#   assert_success
#   assert_output "/opt/jlenv"
# }

# @test "relative path ./../../c for JLENV_ROOT is resolved" {
#   JLENV_ROOT=./../../c run jlenv root
#   assert_success
#   assert_output "/opt/jlenv"
# }
