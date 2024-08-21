# frozen_string_literal: true

require_relative 'bowling_constants'
require_relative 'roll'

class GameHistory
  include BowlingConstants

  attr_reader :tokens

  def initialize(rolls)
    @rolls = rolls

    @tokens = rolls.split(',').map { |s| Roll.new(s) }
  end

  def rest_tokens?
    @tokens.any?
  end

  def peek(offset = 0)
    @tokens[offset]
  end

  def next
    @tokens.shift
  end
end
