# frozen_string_literal: true

require 'date'

require_relative 'options'
require_relative 'options_validator'
require_relative 'highlighter'
require_relative 'day_formatter_julius'
require_relative 'day_formatter_gregorio'
require_relative 'normal_calendar'
require_relative 'normal_canvas_julius'
require_relative 'normal_canvas_gregorio'
require_relative 'transposed_calendar'
require_relative 'transposed_canvas_julius'
require_relative 'transposed_canvas_gregorio'

class CLI
  EXIT_CODE_OK = 0
  EXIT_CODE_PARSE_ERROR = 1
  EXIT_CODE_VALIDATION_ERROR = 2

  def initialize(out_stream, err_stream)
    @out_stream = out_stream
    @err_stream = err_stream

    @params = {}
  end

  def run(argv)
    opt = Options.new

    begin
      @params = opt.parse(argv.dup)
    rescue OptionParser::ParseError => e
      @err_stream.puts e
      @err_stream.puts opt.help
      return EXIT_CODE_PARSE_ERROR
    rescue InvalidArgumentError => e
      @err_stream.puts e
      return EXIT_CODE_VALIDATION_ERROR
    end

    execute
  end

  private

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
