# frozen_string_literal: true

require_relative 'transposed_canvas'

class TransposedCanvasJulius
  include TransposedCanvas

  def initialize(transposed_calendars, day_formatter, whitespace = ' ')
    @calendars = transposed_calendars
    @day_formatter = day_formatter

    validate

    @n_col = 3
    @whitespace = whitespace
  end

  private

  def header(calendars)
    # 表示パターンに応じて年月のヘッダーを作る
    header_str = @whitespace * (4 + 24 * calendars.size)

    # 空文字列をひたすら更新していく
    header_str = substitute_header(header_str, calendars[0], 4)
    header_str = substitute_header(header_str, calendars[1], 4 + 24) unless calendars[1].nil?
    header_str = substitute_header(header_str, calendars[2], 4 + 24 + 24) unless calendars[2].nil?

    header_str
  end
end
