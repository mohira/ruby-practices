# frozen_string_literal: true

class NormalRendererJulius
  def initialize(calendar, day_formatter, whitespace = ' ')
    @calendar = calendar
    @formatter = day_formatter
    @whitespace = whitespace

    @characters_per_line = 28
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
    # 月名の文字数によって左のパディングが決まる。グレゴリオ暦の場合とは異なる。法則は謎。
    size_map = { 3 => 9, 4 => 9, 5 => 8, 6 => 8, 7 => 7, 8 => 7, 9 => 6 }

    size_map[@calendar.month_name.length]
  end

  def pad_right_size
    @characters_per_line - @calendar.month_name.length - @calendar.year.to_s.length - pad_left_size
  end

  def weekdays_label
    @whitespace + NormalCalendar::WEEKDAYS.join(@whitespace * 2) + (@whitespace * 2)
  end

  def body
    @calendar.date_board.map do |rows|
      rows.map { |v| @formatter.do(v) }.join(@whitespace) + (@whitespace * 2)
    end.join("\n")
  end
end
