#!/bin/zsh

assert() {
  cmd=$1
  expected=$2

  actual=$(eval "$cmd")

  if [[ "$expected" == "$actual" ]]; then
    echo "\033[0;32mPASS: $cmd => $actual\033[0m"
  else
    echo "\033[0;31mFAIL: $cmd => $actual (Expected: $expected)\033[0m"
  fi
}

assert './sample.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5' '139'
assert './sample.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X' '164'
assert './sample.rb 0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4' '107'
assert './sample.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0' '134'
assert './sample.rb 6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8' '144'

assert './sample.rb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,4,5' '15'
assert './sample.rb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,X,3,4' '17'
assert './sample.rb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,X,X,5' '25'
assert './sample.rb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,X,X,X' '30'

assert './sample.rb 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0' '0'
assert './sample.rb X,0,0,X,0,0,X,0,0,X,0,0,X,0,0' '50'
assert './sample.rb 0,10,0,10,0,10,0,10,0,10,0,10,0,10,0,10,0,10,0,10,0' '100'
assert './sample.rb 5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5' '150'
assert './sample.rb X,X,X,X,X,X,X,X,X,X,X,X' '300'