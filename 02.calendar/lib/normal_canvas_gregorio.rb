# frozen_string_literal: true

require_relative 'string_helper'
require_relative 'normal_canvas'

class NormalCanvasGregorio
  include NormalCanvas

  def initialize(normal_calendars, day_formatter, whitespace = ' ')
    @calendars = normal_calendars
    @day_formatter = day_formatter

    validate

    @n_col = 3
    @whitespace = whitespace
  end

  private

  def header(calendars)
    # 表示パターンに応じて年月のヘッダーを作る
    padding_size = 22
    header_str = @whitespace * padding_size * calendars.size

    # 空文字列をひたすら更新していく
    middle_char_index = 7
    header_str = substitute_header(header_str, calendars[0], middle_char_index) unless calendars[0].nil?
    header_str = substitute_header(header_str, calendars[1], middle_char_index + padding_size) unless calendars[1].nil?
    header_str = substitute_header(header_str, calendars[2], middle_char_index + padding_size + padding_size) unless calendars[2].nil?

    header_str
  end

  def substitute_header(str, calendar, middle_char_index)
    # 文字列を更新していく。文字列の中央の位置がbase_indexとなるように。
    left_part, middle_part, right_part = split_three_parts(calendar.month_name)

    str = substitute_string(str, left_part, middle_char_index - left_part.length)
    str = substitute_string(str, middle_part, middle_char_index)
    str = substitute_string(str, right_part, middle_char_index + middle_part.length)

    substitute_string(str, " #{calendar.year}", middle_char_index + middle_part.length + right_part.length)
  end

  def weekdays_label(calendars)
    (weekdays * calendars.size).join(@whitespace * 2) + (@whitespace * 2)
  end

  def weekdays
    [%w[Su Mo Tu We Th Fr Sa].join(@whitespace)]
  end
end
