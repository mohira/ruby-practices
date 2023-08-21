#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'lib/cli'

def main
  cli = CLI.new($stdout, $stderr)

  exit cli.run(ARGV)
end

main
