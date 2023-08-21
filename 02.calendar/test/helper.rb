# frozen_string_literal: true

def create_date_helper(year, month)
  # 同一の年月における日付を短く表現するためのメソッド
  proc = ->(y, m, d) { Date.new(y, m, d) }
  proc.curry.call(year, month)
end

def prepare_normal_calendars(months)
  calendars = [
    NormalCalendar.new(2014, 12),
    NormalCalendar.new(2015, 1),
    NormalCalendar.new(2015, 2),
    NormalCalendar.new(2015, 3),
    NormalCalendar.new(2015, 4),
    NormalCalendar.new(2015, 5),
    NormalCalendar.new(2015, 6),
    NormalCalendar.new(2015, 7),
    NormalCalendar.new(2015, 8)
  ]

  calendars.slice(0, months)
end

def prepare_transposed_calendars(months)
  calendars = [
    TransposedCalendar.new(2014, 12),
    TransposedCalendar.new(2015, 1),
    TransposedCalendar.new(2015, 2),
    TransposedCalendar.new(2015, 3),
    TransposedCalendar.new(2015, 4),
    TransposedCalendar.new(2015, 5),
    TransposedCalendar.new(2015, 6),
    TransposedCalendar.new(2015, 7),
    TransposedCalendar.new(2015, 8)
  ]

  calendars.slice(0, months)
end
