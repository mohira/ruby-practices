# frozen_string_literal: true

require 'date'
require 'optparse'

require_relative 'highlighter'
require_relative 'day_formatter_gregorio'
require_relative 'day_formatter_julius'
require_relative 'normal_calendar'
require_relative 'normal_renderer_gregorio'
require_relative 'normal_renderer_julius'
require_relative 'transposed_calendar'
require_relative 'transposed_renderer_gregorio'
require_relative 'transposed_renderer_julius'

class CLI
  USAGE = <<-USAGE
  Displays a one-month calendar. This tool is like the `cal` command but with some differences:
    1. Only one month can be displayed at a time; multiple months' display is not supported.
    2. Output text is in English only.

  Examples
    ./cal.rb                         Display the current month's calendar
    ./cal.rb -m 8                    Display the calendar for current year
    ./cal.rb -m 8 -y 2024            Display the calendar for August 2024

  Options:
  USAGE
  EXIT_CODE_OK = 0
  EXIT_CODE_PARSE_ERROR = 1
  EXIT_CODE_VALIDATION_ERROR = 2

  def initialize(out_stream, err_stream)
    @out_stream = out_stream
    @err_stream = err_stream

    @params = {
      month: Date.today.month,
      year: Date.today.year,
      h: false,
      j: false,
      N: false
    }
  end

  def run(argv)
    return EXIT_CODE_PARSE_ERROR unless parse?(argv)

    return EXIT_CODE_VALIDATION_ERROR unless validate?

    execute
  end

  private

  def parser
    OptionParser.new do |parser|
      parser.banner = USAGE

      parser.on('-m MONTH', '--month MONTH', Integer, 'Display the specified month') { |v| @params[:month] = v }
      parser.on('-y YEAR', '--year YEAR', Integer, 'Display the specified year') { |v| @params[:year] = v }

      parser.on('-h', 'Turns off highlighting of today') { |v| @params[:h] = v }
      parser.on('-j', 'Display Julian days (days one-based, numbered from January 1)') { |v| @params[:j] = v }
      parser.on('-N', 'Display ncal mode') { |v| @params[:N] = v }

      # TODO: 複数月の表示に関連する機能は未実装(-A, -B, -3)
    end
  end

  def parse?(argv)
    begin
      parser.parse!(argv)
    rescue OptionParser::ParseError => e
      @err_stream.puts e
      @err_stream.puts parser.help
      return false
    end

    true
  end

  def validate?
    month = @params[:month]
    year = @params[:year]

    unless (1..12).cover?(month)
      @err_stream.puts "#{month} is not in range (1..12)"
      return false
    end

    unless (1970..2100).cover?(year)
      @err_stream.puts "#{year} is not in range (1970..2100)"
      return false
    end

    # TODO: -A, -B, が設定されている場合は正の整数であること。-3 は -A または -B と共存できないこと
    true
  end

  def execute
    @out_stream.puts renderer.render

    EXIT_CODE_OK
  end

  def renderer
    transposed = @params[:N]
    use_julius = @params[:j]

    case [transposed, use_julius]
    in [true, true]
      TransposedRendererJulius.new(calendar, formatter)
    in [true, false]
      TransposedRendererGregorio.new(calendar, formatter)
    in [false, true]
      NormalRendererJulius.new(calendar, formatter)
    else
      NormalRendererGregorio.new(calendar, formatter)
    end
  end

  def calendar
    @params[:N] ? TransposedCalendar.new(@params[:year], @params[:month]) : NormalCalendar.new(@params[:year], @params[:month])
  end

  def highlighter
    @params[:h] ? NilHighlighter.new : TodayHighlighter.new
  end

  def formatter
    @params[:j] ? DayFormatterJulius.new(highlighter) : DayFormatterGregorio.new(highlighter)
  end
end
