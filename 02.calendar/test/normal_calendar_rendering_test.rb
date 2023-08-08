# frozen_string_literal: true

require 'minitest/autorun'
require 'date'
require_relative '../lib/day_formatter_gregorio'
require_relative '../lib/day_formatter_julius'
require_relative '../lib/highlighter'
require_relative '../lib/normal_renderer_gregorio'
require_relative '../lib/normal_renderer_julius'
require_relative '../lib/normal_calendar'

class NormalCalendarRenderingTest < Minitest::Test
  class GregorioTest < Minitest::Test
    def test_4weeks_start_sun
      assert_render_gregorio(2015, 2)
    end

    def test_5weeks_start_sun
      assert_render_gregorio(2015, 3)
    end

    def test_5weeks_start_not_sun
      assert_render_gregorio(2015, 7)
    end

    def test_6weeks_start_not_sun
      assert_render_gregorio(2015, 8)
    end

    def test_highlight_today
      year = 2015
      month = 2
      fixed_date = Date.new(year, month, 1)

      Date.stub :today, fixed_date do
        calendar = NormalCalendar.new(year, month)
        formatter = DayFormatterGregorio.new(TodayHighlighter.new)
        renderer = NormalRendererGregorio.new(calendar, formatter, ' ')

        actual = renderer.render

        expected = <<~WANT
             February 2015#{'      '}
          Su Mo Tu We Th Fr Sa#{'  '}
          \033[7m 1\033[0m  2  3  4  5  6  7#{'  '}
           8  9 10 11 12 13 14#{'  '}
          15 16 17 18 19 20 21#{'  '}
          22 23 24 25 26 27 28#{'  '}
          #{'                      '}
          #{'                      '}
        WANT

        assert_equal expected, actual
      end
    end

    private

    def assert_render_gregorio(year, month)
      calendar = NormalCalendar.new(year, month)
      formatter = DayFormatterGregorio.new(NilHighlighter.new)
      renderer = NormalRendererGregorio.new(calendar, formatter, ' ')

      actual = renderer.render
      expected = `LANG=en_US.UTF-8; cal #{month} #{year}`

      assert_equal expected, actual
    end
  end

  class JuliusTest < Minitest::Test
    def test_4weeks_start_sun
      assert_render_julius(2015, 2)
    end

    def test_5weeks_start_sun
      assert_render_julius(2015, 3)
    end

    def test_5weeks_start_not_sun
      assert_render_julius(2015, 7)
    end

    def test_6weeks_start_not_sun
      assert_render_julius(2015, 8)
    end

    private

    def assert_render_julius(year, month)
      calendar = NormalCalendar.new(year, month)
      formatter = DayFormatterJulius.new(NilHighlighter.new)
      renderer = NormalRendererJulius.new(calendar, formatter, ' ')

      actual = renderer.render
      expected = `LANG=en_US.UTF-8; cal -j #{month} #{year}`

      assert_equal expected, actual
    end
  end
end
