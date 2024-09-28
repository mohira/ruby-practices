#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require 'open3'
require 'optparse'

MAX_NUMBER_OF_DISPLAY_COLUMNS = 3

def parse_options(argv)
  params = {
    all: false,
    reverse: false,
    long_format: false
  }

  parser = OptionParser.new do |opt|
    opt.on('-a', 'Include directory entries whose names begin with a dot (`.`)') { params[:all] = true }
    opt.on('-r', 'Reverse the order of the sort') { params[:reverse] = true }
    opt.on('-l', 'List files in the long format') { params[:long_format] = true }
  end

  parser.parse!(argv)

  params
end

def fetch_entries(path, all, reverse)
  return [path] if File.file?(path)

  Dir.entries(path)
     .sort
     .then { |entries| all ? entries : entries.reject { |entry| entry.start_with?('.') } }
     .then { |entries| reverse ? entries.reverse : entries }
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

def format_entries_grid(entries_grid)
  return '' if entries_grid == [[]]

  # 各表示列の幅は固定値とする
  columns_width = 1 + entries_grid.flatten.max_by(&:length).length

  entries_grid.map do |row|
    row.map { |entry| entry.ljust(columns_width) }.join
  end.join("\n")
end

def build_default_format_output(entries)
  entries_grid = to_grid(entries)

  format_entries_grid(entries_grid)
end

def extended_attribute(full_path)
  is_macos = RUBY_PLATFORM.match?(/darwin/i)
  return '' unless is_macos

  begin
    stdout, _, stderr = Open3.capture3('xattr', full_path)

    stderr.success? && !stdout.empty? ? '@' : ''
  rescue Errno::ENOENT
    abort 'Command not found: xattr'
  rescue Errno::EACCES
    abort 'Permission denied: xattr'
  rescue StandardError => e
    abort e.message
  end
end

def filetype_and_permissions(stat, full_path)
  filetypes = {
    'file' => '-',
    'directory' => 'd',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'f',
    'link' => 'l',
    'socket' => 's',
    'unknown' => '?'
  }
  file_type_char = filetypes[stat.ftype]

  permission_lookup_table = {
    '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx',
    '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx'
  }
  permissions = format('%o', stat.mode)[-3..].chars.map { |c| permission_lookup_table[c] }.join

  "#{file_type_char}#{permissions}#{extended_attribute(full_path)}"
end

def count_hardlinks(stat)
  stat.nlink
end

def owner_name(stat)
  Etc.getpwuid(stat.uid).name
end

def group_name(stat)
  Etc.getgrgid(stat.gid).name
end

def calculate_file_size(stat)
  stat.size
end

def modified_time(stat)
  mtime = stat.mtime

  if mtime.year == Time.now.year
    mtime.strftime('%-m %e %H:%M')
  else
    mtime.strftime('%-m %e  %Y')
  end
end

def resolve_pathname(full_path)
  basename = File.basename(full_path)

  if File.symlink?(full_path)
    "#{basename} -> #{File.readlink(full_path)}"
  else
    basename
  end
end

def get_file_info(full_path)
  stat = File.lstat(full_path)

  {
    mode: filetype_and_permissions(stat, full_path),
    nlink: count_hardlinks(stat),
    owner: owner_name(stat),
    group: group_name(stat),
    size: calculate_file_size(stat),
    modified_time: modified_time(stat),
    pathname: resolve_pathname(full_path)
  }
end

def format_entries_for_long_listing(file_infos)
  column_widths = {
    nlink: file_infos.map { |info| info[:nlink].to_s.length }.max,
    owner: file_infos.map { |info| info[:owner].length }.max,
    group: file_infos.map { |info| info[:group].length }.max,
    size: file_infos.map { |info| info[:size].to_s.length }.max,
    date: file_infos.map { |info| info[:modified_time].length }.max
  }

  format_string = "%s %#{column_widths[:nlink]}d %-#{column_widths[:owner]}s %-#{column_widths[:group]}s %#{column_widths[:size]}d %#{column_widths[:date]}s %s"

  file_infos.map do |info|
    format(format_string,
           info[:mode],
           info[:nlink],
           info[:owner],
           info[:group],
           info[:size],
           info[:modified_time],
           info[:pathname])
  end.join("\n")
end

def calculate_total_blocks(entries, path)
  entries.map { |entry| File.stat(File.join(path, entry)).blocks }.sum
end

def aggregate_file_info(entries, path)
  entries.map { |entry| get_file_info(File.join(path, entry)) }
end

def build_long_format_output(entries, path)
  total_blocks = calculate_total_blocks(entries, path)

  file_infos = aggregate_file_info(entries, path)
  formatted_entries = format_entries_for_long_listing(file_infos)

  "total #{total_blocks}\n#{formatted_entries}"
end

def main
  params = parse_options(ARGV)

  path = ARGV[0] || '.'

  abort "ls.rb: No such file or directory: #{path}" unless File.exist?(path)

  entries = fetch_entries(path, params[:all], params[:reverse])

  output = params[:long_format] ? build_long_format_output(entries, path) : build_default_format_output(entries)

  puts output unless output.empty?
end

main
