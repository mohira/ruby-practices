# frozen_string_literal: true

class DayFormatterJulius
  def initialize(today_high_light, whitespace = ' ')
    @today_highlighter = today_high_light
    @whitespace = whitespace
  end

  def do(value)
    return format_nil_value if value.nil?

    return format_date_value(value) if value.instance_of?(Date)

    value
  end

  private

  def format_nil_value
    @whitespace * 3
  end

  def format_date_value(date)
    day = date.yday.to_s.rjust(3)

    if Date.today == date
      @today_highlighter.do(day)
    else
      day
    end
  end
end
