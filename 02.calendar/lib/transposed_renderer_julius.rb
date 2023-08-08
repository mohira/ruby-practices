# frozen_string_literal: true

class TransposedRendererJulius
  def initialize(calendar, day_formatter, whitespace = ' ')
    @calendar = calendar
    @formatter = day_formatter
    @whitespace = whitespace

    @characters_per_line = 27
  end

  def render
    "#{year_month_header}\n#{body}\n"
  end

  private

  def year_month_header
    pad_left = @whitespace * pad_left_size
    pad_right = @whitespace * pad_right_size

    "#{pad_left}#{@calendar.month_name} #{@calendar.year}#{pad_right}"
  end

  def pad_left_size
    4
  end

  def pad_right_size
    @characters_per_line - @calendar.month_name.length - @calendar.year.to_s.length - pad_left_size
  end

  def body
    board = @calendar.date_board

    board.map.with_index do |row, index|
      row.unshift(TransposedCalendar::WEEKDAYS[index])
      row.map { |v| @formatter.do(v) }.join(@whitespace)
    end.join("\n")
  end
end
