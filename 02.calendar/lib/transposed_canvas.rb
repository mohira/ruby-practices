# frozen_string_literal: true

module TransposedCanvas
  def validate
    only_transposed_calendar = @calendars.map { |cal| cal.instance_of?(TransposedCalendar) }.all?
    return if only_transposed_calendar

    raise StandardError, 'TransposedCalendarのみで構成された配列でなければいけません'
  end

  def draw
    @calendars.each_slice(@n_col).map do |row_of_calendars|
      [header(row_of_calendars)] + body(row_of_calendars)
    end.join("\n")
  end

  def substitute_header(str, calendar, start_index)
    month_name = calendar.month_name
    year = calendar.year.to_s

    str = substitute_string(str, month_name, start_index)
    substitute_string(str, year, (1 + start_index + month_name.length))
  end

  def body(calendars)
    weekdays = %w[Mo Tu We Th Fr Sa Su]

    dates = (0..6).map do |i|
      days = calendars.map { |cal| format_date_board(cal.date_board[i]) }.join(@whitespace * 1)
      wday = weekdays[i]

      "#{wday}#{@whitespace}#{days}"
    end

    dates.push('') # 末尾に改行が1つ必要
  end

  def format_date_board(date_board)
    date_board.map { |v| @day_formatter.do(v) }.join(@whitespace)
  end
end
