# frozen_string_literal: true

require 'rspec-parameterized'

require_relative '../lib/frames_builder'
require_relative '../lib/game_history'
require_relative '../lib/scoring_system'

RSpec.describe CurrentFrameScoringSystem do
  subject { CurrentFrameScoringSystem.score(frames) }

  let(:frames) { frames_builder.build }
  let(:frames_builder) { FramesBuilder.new(game_history) }
  let(:game_history) { GameHistory.new(raw_roll_log) }

  describe '#score' do
    context 'when some game' do
      where(:expected, :raw_roll_log) do
        [
          [159, '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4'],
          [173, '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X'],
          [125, '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4']
        ]
      end

      with_them do
        it { is_expected.to eq expected }
      end
    end

    context 'when spare of strike in 10th frame' do
      where(:expected, :raw_roll_log, :case) do
        [
          [10, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,10', 'spare'],
          [11, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,9', 'spare'],
          [12, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,8', 'spare'],
          [13, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,7', 'spare'],
          [14, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,6', 'spare'],
          [15, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,5,5', 'spare'],
          [16, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,4', 'spare'],
          [17, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,3', 'spare'],
          [18, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8,2', 'spare'],
          [19, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,9,1', 'spare'],
          [30, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,X', 'strike']
        ]
      end

      with_them do
        it "#{params[:case]} no bonus" do
          is_expected.to eq expected
        end
      end
    end

    context 'when characteristic game' do
      where(:expected, :raw_roll_log, :case) do
        [
          [0, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0', 'all frame gutter'],
          [150, 'X,0,0,X,0,0,X,0,0,X,0,0,X,0,0', 'bonus of all strikes are 0'],
          [150, '5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5', 'all frame spare'],
          [300, 'X,X,X,X,X,X,X,X,X,X,X,X', 'Perfect Game']
        ]
      end

      with_them do
        it params[:case] do
          is_expected.to eq expected
        end
      end
    end
  end
end
