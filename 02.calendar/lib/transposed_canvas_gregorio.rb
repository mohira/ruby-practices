# frozen_string_literal: true

require_relative 'transposed_canvas'

class TransposedCanvasGregorio
  include TransposedCanvas

  def initialize(transposed_calendars, day_formatter, whitespace = ' ')
    @calendars = transposed_calendars
    @day_formatter = day_formatter

    validate

    @n_col = 4
    @whitespace = whitespace
  end

  private

  def header(calendars)
    # 表示パターンに応じて年月のヘッダーを作る
    start_index = 4
    padding_size = 18
    header_str = @whitespace * (start_index + padding_size * calendars.size)

    # 空文字列をひたすら更新していく
    header_str = substitute_header(header_str, calendars[0], start_index)
    header_str = substitute_header(header_str, calendars[1], start_index + padding_size) unless calendars[1].nil?
    header_str = substitute_header(header_str, calendars[2], start_index + padding_size + padding_size) unless calendars[2].nil?
    header_str = substitute_header(header_str, calendars[3], start_index + padding_size + padding_size + padding_size) unless calendars[3].nil?

    header_str
  end
end
