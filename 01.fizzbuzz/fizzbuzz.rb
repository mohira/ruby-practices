#!/usr/bin/env ruby
# frozen_string_literal: true

def to_fizzbuzz(i)
  if i % 3 == 0 && i % 5 == 0
    'FizzBuzz'
  elsif i % 3 == 0
    'Fizz'
  elsif i % 5 == 0
    'Buzz'
  else
    i.to_s
  end
end

def main
  (1..20).each { |i| puts to_fizzbuzz(i) }
end

main
