# frozen_string_literal: true

require 'minitest/autorun'
require 'date'
require_relative '../lib/day_formatter_gregorio'
require_relative '../lib/highlighter'
require_relative '../lib/transposed_renderer_gregorio'
require_relative '../lib/transposed_renderer_julius'
require_relative '../lib/transposed_calendar'

class TransposedCalendarTest < Minitest::Test
  class GregorioTest < Minitest::Test
    def test_4weeks_start_sun
      assert_transposed_calendar_render(2015, 2)
    end

    def test_5weeks_start_sun
      assert_transposed_calendar_render(2015, 3)
    end

    def test_5weeks_start_not_sun
      assert_transposed_calendar_render(2015, 7)
    end

    def test_6weeks_start_not_sun
      assert_transposed_calendar_render(2015, 8)
    end

    private

    def assert_transposed_calendar_render(year, month)
      calendar = TransposedCalendar.new(year, month)
      formatter = DayFormatterGregorio.new(NilHighlighter.new)
      renderer = TransposedRendererGregorio.new(calendar, formatter, ' ')

      actual = renderer.render
      expected = `LANG=en_US.UTF-8; cal -N #{month} #{year}`

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
      calendar = TransposedCalendar.new(year, month)
      formatter = DayFormatterJulius.new(NilHighlighter.new)
      renderer = TransposedRendererJulius.new(calendar, formatter, ' ')

      actual = renderer.render
      expected = `LANG=en_US.UTF-8; cal -N -j #{month} #{year}`

      assert_equal expected, actual
    end
  end
end
