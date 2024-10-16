# frozen_string_literal: true

require 'stringio'
require 'optparse'

EXIT_CODE_OK = 0
EXIT_CODE_ERROR = 1

STAT_FIELDS = %i[lines words bytes].freeze

def count_words(text)
  text.split.count
end

def count_lines(text)
  text.lines.size
end

def count_bytes(text)
  text.bytesize
end

def read_content(path)
  if path.is_a?(IO) || path.is_a?(StringIO)
    { text: path.read, pathname: '' }
  else
    { text: File.read(path), pathname: path }
  end
end

def create_file_info(content)
  {
    pathname: content[:pathname],
    lines: count_lines(content[:text]),
    words: count_words(content[:text]),
    bytes: count_bytes(content[:text])
  }
end

def create_error_info(path, error)
  case error
  when Errno::ENOENT
    { pathname: path, error: "wc: #{path}: No such file or directory" }
  when Errno::EACCES
    { pathname: path, error: "wc: #{path}: Permission denied" }
  else
    { pathname: path, error: "wc: #{path}: #{error.message}" }
  end
end

def extract_file_info(path)
  content = read_content(path)

  create_file_info(content)
rescue StandardError => e
  create_error_info(path, e)
end

def format_output(file_info, options)
  # 各情報は8文字右詰めで表示する
  # 桁数がそれより大きくなる場合の表示は考慮しない
  fields = []

  STAT_FIELDS.each do |key|
    fields << file_info[key].to_s.rjust(8) if options[key]
  end
  fields << " #{file_info[:pathname]}"

  fields.join.rstrip
end

def calculate_total(file_infos)
  total_info = { pathname: 'total', lines: 0, words: 0, bytes: 0 }

  file_infos.reject { |info| info[:error] }.each do |info|
    STAT_FIELDS.each do |key|
      total_info[key] += info[key]
    end
  end

  total_info
end

def parse_options(argv)
  params = { lines: false, words: false, bytes: false }

  OptionParser.new do |opt|
    opt.on('-l', 'Count the number of lines') { params[:lines] = true }
    opt.on('-w', 'Count the number of words') { params[:words] = true }
    opt.on('-c', 'Count the number of bytes') { params[:bytes] = true }
  end.parse!(argv)

  if params.values.all?(false)
    { lines: true, words: true, bytes: true }
  else
    params
  end
end

def wc(in_stream, out_stream, err_stream, argv)
  exit_code = EXIT_CODE_OK

  options = parse_options(argv)

  paths = argv.empty? ? [in_stream] : argv
  file_infos = paths.map { |path| extract_file_info(path) }

  file_infos.each do |file_info|
    if file_info[:error]
      exit_code = EXIT_CODE_ERROR
      err_stream.puts file_info[:error]
    else
      out_stream.puts format_output(file_info, options)
    end
  end

  # 引数が2つ以上ある場合は、エラーが含まれるかどうかに関係なくtotalを計算する
  if file_infos.size >= 2
    total = calculate_total(file_infos)

    out_stream.puts format_output(total, options)
  end

  exit_code
end
