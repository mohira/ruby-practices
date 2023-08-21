# frozen_string_literal: true

require 'minitest/autorun'
require 'date'
require_relative 'helper'
require_relative '../lib/normal_calendar'
require_relative '../lib/normal_canvas_gregorio'
require_relative '../lib/day_formatter_gregorio'
require_relative '../lib/highlighter'

class NormalCanvasGregorioTest < Minitest::Test
  describe 'NormalCanvasJulius' do
    [
      [1, 'LANG=en_US.UTF-8; cal         -m 12 2014'],
      [1, 'LANG=en_US.UTF-8; cal         -m 12 2014'],
      [2, 'LANG=en_US.UTF-8; cal -B1     -m  1 2015'],
      [3, 'LANG=en_US.UTF-8; cal -B1 -A1 -m  1 2015'],
      [4, 'LANG=en_US.UTF-8; cal -B1 -A2 -m  1 2015'],
      [5, 'LANG=en_US.UTF-8; cal -B1 -A3 -m  1 2015'],
      [6, 'LANG=en_US.UTF-8; cal -B1 -A4 -m  1 2015'],
      [7, 'LANG=en_US.UTF-8; cal -B1 -A5 -m  1 2015'],
      [8, 'LANG=en_US.UTF-8; cal -B1 -A6 -m  1 2015'],
      [9, 'LANG=en_US.UTF-8; cal -B1 -A7 -m  1 2015']
    ].each_with_index do |(months, expected_command), index|
      it "test #{index + 1}" do
        expected = `#{expected_command}`

        canvas = NormalCanvasGregorio.new(prepare_normal_calendars(months), DayFormatterGregorio.new(NilHighlighter.new))

        assert_equal expected, canvas.draw
      end
    end
  end
end
