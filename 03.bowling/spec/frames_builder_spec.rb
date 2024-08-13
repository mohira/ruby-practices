# frozen_string_literal: true

require 'rspec-parameterized'

require_relative '../lib/bowling_constants'
require_relative '../lib/frame'
require_relative '../lib/frames_builder'
require_relative '../lib/roll'
require_relative '../lib/game_history'
require_relative '../lib/scoring_system'

RSpec.describe FramesBuilder do
  subject { frames_builder.build }

  let(:frames_builder) { FramesBuilder.new(roll_history_parser) }
  let(:roll_history_parser) { GameHistory.new(rolls) }

  where(:rolls, :expected) do
    [
      [
        '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5',
        [
          Frame.new([Roll.new('6'), Roll.new('3')]),
          Frame.new([Roll.new('9'), Roll.new('0')]),
          Frame.new([Roll.new('0'), Roll.new('3')]),
          Frame.new([Roll.new('8'), Roll.new('2')]),
          Frame.new([Roll.new('7'), Roll.new('3')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('9'), Roll.new('1')]),
          Frame.new([Roll.new('8'), Roll.new('0')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('6'), Roll.new('4'), Roll.new('5')])
        ]
      ],
      [
        '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X',
        [
          Frame.new([Roll.new('6'), Roll.new('3')]),
          Frame.new([Roll.new('9'), Roll.new('0')]),
          Frame.new([Roll.new('0'), Roll.new('3')]),
          Frame.new([Roll.new('8'), Roll.new('2')]),
          Frame.new([Roll.new('7'), Roll.new('3')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('9'), Roll.new('1')]),
          Frame.new([Roll.new('8'), Roll.new('0')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('X'), Roll.new('X'), Roll.new('X')])
        ]
      ],
      [
        '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4',
        [Frame.new([Roll.new('0'), Roll.new('10')]),
         Frame.new([Roll.new('1'), Roll.new('5')]),
         Frame.new([Roll.new('0'), Roll.new('0')]),
         Frame.new([Roll.new('0'), Roll.new('0')]),
         Frame.new([Roll.new('X')]),
         Frame.new([Roll.new('X')]),
         Frame.new([Roll.new('X')]),
         Frame.new([Roll.new('5'), Roll.new('1')]),
         Frame.new([Roll.new('8'), Roll.new('1')]),
         Frame.new([Roll.new('0'), Roll.new('4')])]
      ],
      [
        '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8',
        [
          Frame.new([Roll.new('6'), Roll.new('3')]),
          Frame.new([Roll.new('9'), Roll.new('0')]),
          Frame.new([Roll.new('0'), Roll.new('3')]),
          Frame.new([Roll.new('8'), Roll.new('2')]),
          Frame.new([Roll.new('7'), Roll.new('3')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('9'), Roll.new('1')]),
          Frame.new([Roll.new('8'), Roll.new('0')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('X'), Roll.new('1'), Roll.new('8')])
        ]
      ],
      [
        'X,X,X,X,X,X,X,X,X,X,X,X',
        [
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('X'), Roll.new('X'), Roll.new('X')])
        ]
      ],
      [
        'X,0,0,X,0,0,X,0,0,X,0,0,X,0,0',
        [
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('0'), Roll.new('0')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('0'), Roll.new('0')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('0'), Roll.new('0')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('0'), Roll.new('0')]),
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('0'), Roll.new('0')])
        ]
      ],
      [
        'X,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0',
        [
          Frame.new([Roll.new('X')]),
          Frame.new([Roll.new('0'), Roll.new('0')]),
          Frame.new([Roll.new('0'), Roll.new('0')]),
          Frame.new([Roll.new('0'), Roll.new('0')]),
          Frame.new([Roll.new('0'), Roll.new('0')]),
          Frame.new([Roll.new('0'), Roll.new('0')]),
          Frame.new([Roll.new('0'), Roll.new('0')]),
          Frame.new([Roll.new('0'), Roll.new('0')]),
          Frame.new([Roll.new('0'), Roll.new('0')]),
          Frame.new([Roll.new('0'), Roll.new('0')])
        ]
      ]
    ]
  end

  with_them do
    it { is_expected.to eq expected }
  end
end
