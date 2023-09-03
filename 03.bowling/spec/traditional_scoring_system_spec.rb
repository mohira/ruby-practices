# frozen_string_literal: true

require 'rspec-parameterized'

require_relative '../lib/frames_builder'
require_relative '../lib/game_history'
require_relative '../lib/scoring_system'

RSpec.describe TraditionalFrameScoringSystem do
  subject { TraditionalFrameScoringSystem.score(frames) }

  let(:frames) { frames_builder.build }
  let(:frames_builder) { FramesBuilder.new(game_history) }
  let(:game_history) { GameHistory.new(raw_roll_log) }

  describe '#score' do
    context 'when some game' do
      where(:expected, :raw_roll_log) do
        [
          [139, '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,6,4,5'],
          [164, '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,X,X'],
          [107, '0,10,1,5,0,0,0,0,X,X,X,5,1,8,1,0,4'],
          [134, '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,0,0'],
          [144, '6,3,9,0,0,3,8,2,7,3,X,9,1,8,0,X,X,1,8']
        ]
      end

      with_them do
        it { is_expected.to eq expected }
      end
    end

    context 'when spare of strike in 10th frame' do
      where(:expected, :raw_roll_log, :case) do
        [
          [15, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,6,4,5', 'spare'],
          [17, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,X,3,4', 'strike'],
          [25, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,X,X,5', 'double'],
          [30, '0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,X,X,X', 'turkey']
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
          [50, 'X,0,0,X,0,0,X,0,0,X,0,0,X,0,0', 'bonus of all strikes is 0'],
          [100, '0,10,0,10,0,10,0,10,0,10,0,10,0,10,0,10,0,10,0,10,0', 'bonus of all spares is 0'],
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
