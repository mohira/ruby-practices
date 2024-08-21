# frozen_string_literal: true

require_relative 'bowling_constants'

class PlainScoringRule
  def initialize(frames)
    @frames = frames
  end

  def score
    @frames.sum(&:total_knocked_down_pins)
  end
end

class FrameBonusScoringRule
  include BowlingConstants

  def initialize(frames)
    @frames = frames
    @flatten_rolls = @frames.map(&:rolls).flatten # 「次の投球」や「次の次の投球」の取得を楽にするためにflatten
  end

  def score
    @scanned_roll_index = 0 # 冪等な処理にするためにここで初期化

    @frames.first((NUMBER_OF_ALL_FRAMES - 1)).each.sum do |frame|
      @scanned_roll_index += frame.throw_count

      frame_bonus(frame)
    end
  end

  private

  def frame_bonus(frame)
    if frame.spare?
      spare_bonus
    elsif frame.strike?
      strike_bonus
    else
      0
    end
  end

  def spare_bonus
    next_roll.knocked_down_pins
  end

  def strike_bonus
    next_roll.knocked_down_pins + next_second_roll.knocked_down_pins
  end

  def next_roll
    @flatten_rolls[@scanned_roll_index]
  end

  def next_second_roll
    @flatten_rolls[@scanned_roll_index + 1]
  end
end
