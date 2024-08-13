# frozen_string_literal: true

require_relative 'scoring_rule'

class TraditionalFrameScoringSystem
  def self.score(frames)
    plain_score = PlainScoringRule.new(frames).score
    bonus_score = FrameBonusScoringRule.new(frames).score

    plain_score + bonus_score
  end
end
