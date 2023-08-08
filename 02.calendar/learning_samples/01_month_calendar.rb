# frozen_string_literal: true

require 'date'
require 'optparse'

WHITE_SPACE = ' '

def header(year, month)
  year_month = "#{month}月 #{year}"

  pad_left_size = 6
  pad_right_size = 22 - pad_left_size.size - year_month.size

  pad_left = WHITE_SPACE * pad_left_size
  pad_right = WHITE_SPACE * pad_right_size

  "#{pad_left}#{year_month}#{pad_right}"
end

def weekdays_label
  %w[日 月 火 水 木 金 土].join(WHITE_SPACE)
end

def body(year, month)
  first_date = Date.new(year, month, 1)
  last_date = Date.new(year, month, -1)

  dates = [WHITE_SPACE * 3] * first_date.wday # offset

  (first_date..last_date).each do |date|
    dates.push(date.strftime('%e'))
    dates.push(date.saturday? ? "\n" : WHITE_SPACE)
  end

  dates.join
end

def string_of_a_month_calendar(year, month)
  [header(year, month), weekdays_label, body(year, month)].join("\n")
end

def main
  year = 2023

  (1..12).each do |month|
    puts string_of_a_month_calendar(year, month)
  end
end

main
