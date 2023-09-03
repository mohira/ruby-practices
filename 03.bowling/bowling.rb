#!/usr/bin/env ruby

# frozen_string_literal: true

require_relative 'lib/frames_builder'
require_relative 'lib/game_history'
require_relative 'lib/scoring_system'

def main
  game_history = GameHistory.new(ARGV[0])
  frames_builder = FramesBuilder.new(game_history)
  frames = frames_builder.build

  score = TraditionalFrameScoringSystem.score(frames)

  puts score
end

main
