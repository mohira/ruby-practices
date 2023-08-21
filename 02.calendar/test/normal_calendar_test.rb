# frozen_string_literal: true

require 'minitest/autorun'
require 'date'
require_relative 'helper'
require_relative '../lib/normal_calendar'

class NormalCalendarTest < Minitest::Test
  def test_string_representation
    calendar = NormalCalendar.new(2015, 2)

    expected = <<~WANT
      February 2015
      Su Mo Tu We Th Fr Sa
       1  2  3  4  5  6  7
       8  9 10 11 12 13 14
      15 16 17 18 19 20 21
      22 23 24 25 26 27 28
      Na Na Na Na Na Na Na
      Na Na Na Na Na Na Na
    WANT

    assert_equal expected, calendar.to_s
  end

  def test_4weeks_start_sun
    year = 2015
    month = 2

    calendar = NormalCalendar.new(year, month)

    d = create_date_helper(year, 2)

    expected = [
      [d[1], d[2], d[3], d[4], d[5], d[6], d[7]],
      [d[8], d[9], d[10], d[11], d[12], d[13], d[14]],
      [d[15], d[16], d[17], d[18], d[19], d[20], d[21]],
      [d[22], d[23], d[24], d[25], d[26], d[27], d[28]],
      [nil, nil, nil, nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil]
    ]

    assert_equal expected, calendar.date_board
  end

  def test_5weeks_start_sun
    year = 2015
    month = 3

    calendar = NormalCalendar.new(year, month)
    d = create_date_helper(year, month)

    expected = [
      [d[1], d[2], d[3], d[4], d[5], d[6], d[7]],
      [d[8], d[9], d[10], d[11], d[12], d[13], d[14]],
      [d[15], d[16], d[17], d[18], d[19], d[20], d[21]],
      [d[22], d[23], d[24], d[25], d[26], d[27], d[28]],
      [d[29], d[30], d[31], nil, nil, nil, nil],
      [nil, nil, nil, nil, nil, nil, nil]
    ]
    assert_equal expected, calendar.date_board
  end

  def test_5weeks_start_not_sun
    year = 2015
    month = 7

    calendar = NormalCalendar.new(year, month)
    d = create_date_helper(year, month)

    expected = [
      [nil, nil, nil, d[1], d[2], d[3], d[4]],
      [d[5], d[6], d[7], d[8], d[9], d[10], d[11]],
      [d[12], d[13], d[14], d[15], d[16], d[17], d[18]],
      [d[19], d[20], d[21], d[22], d[23], d[24], d[25]],
      [d[26], d[27], d[28], d[29], d[30], d[31], nil],
      [nil, nil, nil, nil, nil, nil, nil]
    ]
    assert_equal expected, calendar.date_board
  end

  def test_6weeks_start_not_sun
    year = 2015
    month = 8

    calendar = NormalCalendar.new(year, month)
    d = create_date_helper(year, month)

    expected = [
      [nil, nil, nil, nil, nil, nil, d[1]],
      [d[2], d[3], d[4], d[5], d[6], d[7], d[8]],
      [d[9], d[10], d[11], d[12], d[13], d[14], d[15]],
      [d[16], d[17], d[18], d[19], d[20], d[21], d[22]],
      [d[23], d[24], d[25], d[26], d[27], d[28], d[29]],
      [d[30], d[31], nil, nil, nil, nil, nil]
    ]
    assert_equal expected, calendar.date_board
  end
end
