# frozen_string_literal: true

require_relative 'bowling_constants'

class Frame
  include BowlingConstants

  attr_reader :rolls

  def initialize(rolls)
    @rolls = rolls
  end

  def inspect
    "Frame([#{rolls.map(&:mark).join(',')}])"
  end

  def ==(other)
    other.is_a?(Frame) && @rolls == other.rolls
  end

  def throw_count
    @rolls.size
  end

  def first_roll
    @rolls[0]
  end

  def second_roll
    @rolls[1]
  end

  def third_roll
    @rolls[2]
  end

  def strike?
    first_roll.knocked_down_pins == PINS_OF_FRAME
  end

  def spare?
    return false if strike?

    (first_roll.knocked_down_pins + second_roll.knocked_down_pins) == PINS_OF_FRAME
  end

  def total_knocked_down_pins
    @rolls.sum(&:knocked_down_pins)
  end
end
