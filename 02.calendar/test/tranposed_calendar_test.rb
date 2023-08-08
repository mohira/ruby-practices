# frozen_string_literal: true

require 'minitest/autorun'
require 'date'
require_relative 'helper'
require_relative '../lib/transposed_calendar'

class TransposedCalendarTest < Minitest::Test
  def test_string_representation
    calendar = TransposedCalendar.new(2015, 2)

    expected = <<~WANT
      February 2015
      Mo Na  2  9 16 23 Na
      Tu Na  3 10 17 24 Na
      We Na  4 11 18 25 Na
      Th Na  5 12 19 26 Na
      Fr Na  6 13 20 27 Na
      Sa Na  7 14 21 28 Na
      Su  1  8 15 22 Na Na
    WANT

    assert_equal expected, calendar.to_s
  end

  def test_4weeks_start_sun
    year = 2015
    month = 2

    calendar = TransposedCalendar.new(year, month)

    d = create_date_helper(year, month)

    expected = [
      [nil, d[2], d[9], d[16], d[23], nil],
      [nil, d[3], d[10], d[17], d[24], nil],
      [nil, d[4], d[11], d[18], d[25], nil],
      [nil, d[5], d[12], d[19], d[26], nil],
      [nil, d[6], d[13], d[20], d[27], nil],
      [nil, d[7], d[14], d[21], d[28], nil],
      [d[1], d[8], d[15], d[22], nil, nil]
    ]

    assert_equal expected, calendar.date_board
  end

  def test_5weeks_start_sun
    year = 2015
    month = 3

    calendar = TransposedCalendar.new(year, month)

    d = create_date_helper(year, month)

    expected = [
      [nil, d[2], d[9], d[16], d[23], d[30]],
      [nil, d[3], d[10], d[17], d[24], d[31]],
      [nil, d[4], d[11], d[18], d[25], nil],
      [nil, d[5], d[12], d[19], d[26], nil],
      [nil, d[6], d[13], d[20], d[27], nil],
      [nil, d[7], d[14], d[21], d[28], nil],
      [d[1], d[8], d[15], d[22], d[29], nil]
    ]

    assert_equal expected, calendar.date_board
  end

  def test_5weeks_start_not_sun
    year = 2015
    month = 7

    calendar = TransposedCalendar.new(year, month)

    d = create_date_helper(year, month)

    expected = [
      [nil, d[6], d[13], d[20], d[27], nil],
      [nil, d[7], d[14], d[21], d[28], nil],
      [d[1], d[8], d[15], d[22], d[29], nil],
      [d[2], d[9], d[16], d[23], d[30], nil],
      [d[3], d[10], d[17], d[24], d[31], nil],
      [d[4], d[11], d[18], d[25], nil, nil],
      [d[5], d[12], d[19], d[26], nil, nil]
    ]

    assert_equal expected, calendar.date_board
  end

  def test_6weeks_start_not_sun
    year = 2015
    month = 8

    calendar = TransposedCalendar.new(year, month)

    d = create_date_helper(year, month)

    expected = [
      [nil, d[3], d[10], d[17], d[24], d[31]],
      [nil, d[4], d[11], d[18], d[25], nil],
      [nil, d[5], d[12], d[19], d[26], nil],
      [nil, d[6], d[13], d[20], d[27], nil],
      [nil, d[7], d[14], d[21], d[28], nil],
      [d[1], d[8], d[15], d[22], d[29], nil],
      [d[2], d[9], d[16], d[23], d[30], nil]
    ]

    assert_equal expected, calendar.date_board
  end
end
