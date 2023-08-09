# frozen_string_literal: true

module NormalCanvas
  def validate
    is_only_normal_calender = @calendars.map { |cal| cal.instance_of?(NormalCalendar) }.all?
    return if is_only_normal_calender

    raise StandardError, 'NormalCalendarのみで構成された配列でなければいけません'
  end

  def draw
    @calendars.each_slice(@n_col).map do |row_of_calendars|
      [header(row_of_calendars)] + [weekdays_label(row_of_calendars)] + body(row_of_calendars)
    end.join("\n")
  end

  def body(calendars)
    dates = (0..5).map do |i|
      calendars.map { |cal| format_date_board(cal.date_board[i]) }.join(@whitespace * 2) + (@whitespace * 2)
    end

    dates.push('') # 末尾に改行が1つ必要
  end

  def format_date_board(date_board)
    date_board.map { |date| @day_formatter.do(date) }.join(@whitespace * 1)
  end
end
