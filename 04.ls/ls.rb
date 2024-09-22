#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

MAX_NUMBER_OF_DISPLAY_COLUMNS = 3

def fetch_entries(path, all)
  return [path] if File.file?(path)

  Dir.entries(path)
     .sort
     .then { |entries| all ? entries : entries.reject { |entry| entry.start_with?('.') } }
end

def to_grid(entries)
  return [[]] if entries.empty?

  number_of_display_rows = (entries.count + MAX_NUMBER_OF_DISPLAY_COLUMNS - 1) / MAX_NUMBER_OF_DISPLAY_COLUMNS

  # 矩形の表示枠を用意してnilは切り詰める
  grid = Array.new(MAX_NUMBER_OF_DISPLAY_COLUMNS * number_of_display_rows) { |i| entries[i] }
  grid.each_slice(number_of_display_rows)
      .to_a.transpose
      .map { |row| row.reject(&:nil?) }
end

def stringify_entries_grid(entries_grid)
  return '' if entries_grid == [[]]

  # 各表示列の幅は固定値とする
  columns_width = 1 + entries_grid.flatten.max_by(&:length).length

  entries_grid.map do |row|
    row.map { |entry| entry.ljust(columns_width) }.join
  end.join("\n")
end

def main
  params = {
    all: false
  }

  parser = OptionParser.new do |opt|
    opt.on('-a', 'Include directory entries whose names begin with a dot (`.`)') { params[:all] = true }
  end

  parser.parse!(ARGV)

  path = ARGV[0] || '.'

  abort "ls.rb: No such file or directory: #{path}" unless File.exist?(path)

  entries = fetch_entries(path, params[:all])
  entries_grid = to_grid(entries)

  ls_result = stringify_entries_grid(entries_grid)

  puts ls_result unless ls_result.empty?
end

main
