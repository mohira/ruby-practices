# frozen_string_literal: true

require_relative 'string_helper'
require_relative 'normal_canvas'

class NormalCanvasJulius
  include NormalCanvas

  def initialize(calendars, day_formatter, whitespace = ' ')
    @calendars = calendars
    @day_formatter = day_formatter

    validate

    @n_col = 2
    @whitespace = whitespace
  end

  private

  def header(calendars)
    # 表示パターンに応じて年月のヘッダーを作る
    header_str = @whitespace * 29 * calendars.size

    # 空文字列をひたすら更新していく
    header_str = substitute_header(header_str, calendars[0], 10) unless calendars[0].nil?
    header_str = substitute_header(header_str, calendars[1], 10 + 29) unless calendars[1].nil?

    header_str
  end

  def substitute_header(str, calendar, middle_char_index)
    # 文字列を上書きする。文字列の中央の位置がbase_indexとなるように。
    left_part, middle_part, right_part = split_three_parts(calendar.month_name)

    offset = calendar.month_name.length.even? ? 1 : 0

    str = substitute_string(str, left_part, offset + middle_char_index - left_part.length)
    str = substitute_string(str, middle_part, offset + middle_char_index)
    str = substitute_string(str, right_part, offset + middle_char_index + middle_part.length)

    substitute_string(str, " #{calendar.year}", offset + middle_char_index + middle_part.length + right_part.length)
  end

  def weekdays_label(calendars)
    ([weekdays.join(@whitespace)] * calendars.size).join(@whitespace * 2) + (@whitespace * 2)
  end

  def weekdays
    %w[Su Mo Tu We Th Fr Sa].map { |wday| wday.rjust(3) }.to_a
  end
end
