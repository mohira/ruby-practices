#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'wc'

def main
  exit wc($stdin, $stdout, $stderr, ARGV)
end

main
