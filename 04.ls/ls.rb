#!/usr/bin/env ruby
# frozen_string_literal: true

def list_entries(dir)
  Dir.entries(dir)
end

def filter_entries(entries)
  entries.reject { |e| e.start_with?('.') }
end

def sort_asc(entries)
  entries.sort
end

def format_entries_to_grid(entries)
  # lsでの出力形態を表現した2次元配列を作る

  # 仕様: 横に「最大3列」を維持して表示する
  # 仕様: 一般的なlsと異なり、表示端末のウィンドウ幅は表示列の数に影響しない
  n_cols = 3
  n_rows = (entries.count + n_cols - 1) / n_cols # 整数の切り上げ

  # 矩形の表示枠を用意してnilは切り詰める
  grid = Array.new(n_cols * n_rows) { |i| entries[i] }
  grid.each_slice(n_rows)
      .to_a.transpose
      .map { |row| row.reject(&:nil?) }
end

def stringify_entries_grid(entries_grid)
  # 出力用の文字列を組み立てる

  # 列の幅は すべて等しい かつ エントリーの最大文字長+1 で固定する
  col_width = 1 + entries_grid.flatten.max_by(&:length).length

  entries_grid.map do |row|
    row.map { |entry| entry.ljust(col_width) }.join
  end.join("\n")
end

def main
  dir = ARGV[0] || '.'

  unless File.exist?(dir)
    warn "ls.rb: No such file or directory: #{dir}"
    exit 1
  end

  if File.file?(dir)
    puts dir
    exit 0
  end

  entries_raw = list_entries(dir)

  exit 0 if entries_raw.empty?

  entries = sort_asc(filter_entries(entries_raw))

  entries_grid = format_entries_to_grid(entries)

  puts stringify_entries_grid(entries_grid)
end

main
