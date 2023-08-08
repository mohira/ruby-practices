# frozen_string_literal: true

class NormalRendererGregorio
  def initialize(calendar, day_formatter, whitespace = ' ')
    @calendar = calendar
    @formatter = day_formatter
    @whitespace = whitespace

    @characters_per_line = 21
  end

  def render
    "#{year_month_header}\n#{weekdays_label}\n#{body}\n"
  end

  private

  def year_month_header
    pad_left = @whitespace * pad_left_size
    pad_right = @whitespace * pad_right_size

    "#{pad_left}#{@calendar.month_name} #{@calendar.year}#{pad_right}"
  end

  def pad_left_size
    # 月名の文字数によって左のパディングが決まる。ユリウス暦の場合とは異なる。法則は謎。
    size_map = { 3 => 3, 4 => 5, 5 => 5, 6 => 4, 7 => 4, 8 => 3, 9 => 3 }
    size_map[@calendar.month_name.length]
  end

  def pad_right_size
    @characters_per_line - @calendar.month_name.length - @calendar.year.to_s.length - pad_left_size
  end

  def weekdays_label
    NormalCalendar::WEEKDAYS.join(@whitespace) + (@whitespace * 2)
  end

  def body
    @calendar.date_board.map do |rows|
      rows.map { |v| @formatter.do(v) }.join(@whitespace) + (@whitespace * 2)
    end.join("\n")
  end
end
