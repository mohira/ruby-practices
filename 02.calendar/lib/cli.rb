# frozen_string_literal: true

require 'date'
require 'optparse'

require_relative 'highlighter'
require_relative 'day_formatter_gregorio'
require_relative 'day_formatter_julius'
require_relative 'normal_calendar'
require_relative 'transposed_calendar'
require_relative 'normal_canvas_gregorio'
require_relative 'transposed_canvas_gregorio'

class CLI
  USAGE = <<-USAGE
  Displays a calendar like the `cal` command.

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
      N: false,
      Three: false
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

      parser.on('-A MONTH', Integer, 'Display the number of months after the current month') { |v| @params[:A] = v }
      parser.on('-B MONTH', Integer, 'Display the number of months before the current month') { |v| @params[:B] = v }
      parser.on('-3', 'Display the previous, current and next month surrounding today') { |v| @params[:Three] = v }
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

    if @params[:Three]
      unless @params[:A].nil?
        @err_stream.puts '-3 together with -A is not supported'
        return false
      end

      unless @params[:B].nil?
        @err_stream.puts '-3 together with -B is not supported'
        return false
      end
    end

    unless @params[:A].nil? || @params[:A].positive?
      @err_stream.puts 'Argument to -A must be positive'
      return false
    end

    unless @params[:B].nil? || @params[:B].positive?
      @err_stream.puts 'Argument to -B must be positive'
      return false
    end

    true
  end

  def execute
    @out_stream.puts canvas(calendars).draw

    EXIT_CODE_OK
  end

  def year_month_pairs
    n_prev = @params[:Three] ? 1 : @params[:B] || 0
    n_next = @params[:Three] ? 1 : @params[:A] || 0

    base_date = Date.new(@params[:year], @params[:month])
    start_date = base_date.prev_month(n_prev)
    last_date = base_date.next_month(n_next)

    (start_date..last_date).map { |date| [date.year, date.month] }.uniq
  end

  def use_calendar_class
    @params[:N] ? TransposedCalendar : NormalCalendar
  end

  def calendars
    year_month_pairs.map do |year, month|
      use_calendar_class.new(year, month)
    end.to_a
  end

  def canvas(calendars)
    transposed = @params[:N]
    use_julius = @params[:j]

    case [transposed, use_julius]
    in [true, true]
      TransposedCanvasJulius.new(calendars, formatter)
    in [true, false]
      TransposedCanvasGregorio.new(calendars, formatter)
    in [false, true]
      NormalCanvasJulius.new(calendars, formatter)
    else
      NormalCanvasGregorio.new(calendars, formatter)
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
