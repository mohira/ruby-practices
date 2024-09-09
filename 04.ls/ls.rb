#!/usr/bin/env ruby
# frozen_string_literal: true

MAX_NUMBER_OF_DISPLAY_COLUMNS = 3

def format_entries_to_grid(entries)
  # lsでの出力形態を表現した2次元配列を作る
  number_of_display_rows = (entries.count + MAX_NUMBER_OF_DISPLAY_COLUMNS - 1) / MAX_NUMBER_OF_DISPLAY_COLUMNS

  # 矩形の表示枠を用意してnilは切り詰める
  grid = Array.new(MAX_NUMBER_OF_DISPLAY_COLUMNS * number_of_display_rows) { |i| entries[i] }
  grid.each_slice(number_of_display_rows)
      .to_a.transpose
      .map { |row| row.reject(&:nil?) }
end

def stringify_entries_grid(entries_grid)
  # 各表示列の幅は固定値とする
  columns_width = 1 + entries_grid.flatten.max_by(&:length).length

  entries_grid.map do |row|
    row.map { |entry| entry.ljust(columns_width) }.join
  end.join("\n")
end

def main
  dir = ARGV[0] || '.'

  abort "ls.rb: No such file or directory: #{dir}" unless File.exist?(dir)

  if File.file?(dir)
    puts dir
    exit
  end

  entries = Dir.entries(dir)
               .reject { |e| e.start_with?('.') }
               .sort

  exit if entries.empty?

  entries_grid = format_entries_to_grid(entries)

  puts stringify_entries_grid(entries_grid)
end

main
