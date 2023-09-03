# frozen_string_literal: true

require_relative 'bowling_constants'

class InvalidMarkError < StandardError; end

class Roll
  VALID_MARK_PATTERN = /\A[\dX]|10\z/

  attr_reader :mark

  include BowlingConstants

  def initialize(mark)
    @mark = mark

    validate
  end

  def inspect
    "Roll(#{@mark}(#{knocked_down_pins}))"
  end

  def ==(other)
    other.is_a?(Roll) && @mark == other.mark
  end

  def knocked_down_pins
    @mark == 'X' ? 10 : @mark.to_i
  end

  private

  def validate
    raise InvalidMarkError, "#{@mark} is is invalid" unless VALID_MARK_PATTERN.match?(@mark)
  end
end
