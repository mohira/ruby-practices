# frozen_string_literal: true

require_relative 'bowling_constants'
require_relative 'frame'
class FramesBuilder
  include BowlingConstants

  def initialize(game_history)
    @game_history = game_history
    @frames = []
  end

  def build
    @frames << create_frame while @game_history.rest_tokens?

    @frames
  end

  def last_frame?
    @frames.size == (NUMBER_OF_ALL_FRAMES - 1)
  end

  def strike?
    @game_history.peek.knocked_down_pins == PINS_OF_FRAME
  end

  def spare?
    @game_history.peek.knocked_down_pins + @game_history.peek(1).knocked_down_pins == PINS_OF_FRAME
  end

  def create_frame
    Frame.new((1..throw_count).map { @game_history.next })
  end

  def throw_count
    if last_frame? && (strike? || spare?)
      3
    elsif strike?
      1
    else
      2
    end
  end
end
