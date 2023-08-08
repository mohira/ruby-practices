# frozen_string_literal: true

def create_date_helper(year, month)
  # 同一の年月における日付を短く表現するためのメソッド
  proc = ->(y, m, d) { Date.new(y, m, d) }
  proc.curry.call(year, month)
end
