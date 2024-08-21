# frozen_string_literal: true

require 'rspec-parameterized'
require_relative '../lib/frame'
require_relative '../lib/roll'

RSpec.describe Frame do
  describe '#strike?' do
    subject { Frame.new(rolls).strike? }

    context 'when all of the pins have been knocked down on the first roll' do
      let(:rolls) { [Roll.new('X')] }

      it 'strike' do
        is_expected.to be true
      end
    end

    context 'when two roll' do
      let(:rolls) { [Roll.new('1'), Roll.new('9')] }
      it 'not strike' do
        is_expected.to be false
      end
    end

    context 'when spare' do
      let(:rolls) { [Roll.new('0'), Roll.new('10')] }
      it 'not strike' do
        is_expected.to be false
      end
    end
  end

  describe '#spare?' do
    subject { Frame.new(rolls).spare? }

    context 'when two throw knocked down 10 pins' do
      where(:rolls) do
        [
          [[Roll.new('0'), Roll.new('10')]],
          [[Roll.new('1'), Roll.new('9')]]
        ]
      end

      with_them 'spare' do
        it { is_expected.to be true }
      end
    end

    context 'when two throw knocked down under 10 pins' do
      let(:rolls) { [Roll.new('0'), Roll.new('9')] }
      it 'not spare' do
        is_expected.to be false
      end
    end

    context 'when strike' do
      let(:rolls) { [Roll.new('X')] }
      it 'not spare' do
        is_expected.to be false
      end
    end
  end

  describe '#total_knocked_down_pins' do
    subject { Frame.new(rolls).total_knocked_down_pins }

    where(:rolls, :expected) do
      [
        [[Roll.new('X')], 10],
        [[Roll.new('3'), Roll.new('4')], 7],
        [[Roll.new('4'), Roll.new('6')], 10],
        [[Roll.new('0'), Roll.new('10')], 10],
        [[Roll.new('1'), Roll.new('9'), Roll.new('X')], 20],
        [[Roll.new('X'), Roll.new('X'), Roll.new('X')], 30]
      ]
    end

    with_them do
      it { is_expected.to eq expected }
    end
  end

  describe '#==' do
    subject { object1 == object2 }

    context 'when marks are equal' do
      where(:object1, :object2) do
        [
          [
            Frame.new([Roll.new('X'), Roll.new('X')]),
            Frame.new([Roll.new('X'), Roll.new('X')])
          ],

          [
            Frame.new([Roll.new('1'), Roll.new('1')]),
            Frame.new([Roll.new('1'), Roll.new('1')])
          ]
        ]
      end

      with_them do
        it { is_expected.to be true }
      end
    end

    context 'when marks are not equal' do
      where(:object1, :object2) do
        [
          [
            Frame.new([Roll.new('X'), Roll.new('X')]),
            Frame.new([Roll.new('0'), Roll.new('10')])
          ],

          [
            Frame.new([Roll.new('1'), Roll.new('1')]),
            Frame.new([Roll.new('1'), Roll.new('2')])
          ]
        ]
      end

      with_them do
        it { is_expected.to be false }
      end
    end

    context 'when comparing with different class' do
      where(:object1, :object2) do
        [
          [
            Frame.new([Roll.new('X'), Roll.new('X')]),
            %w[X X]
          ]
        ]
      end

      with_them do
        it { is_expected.to be false }
      end
    end
  end

  describe '#throw_count' do
    subject { Frame.new(rolls).throw_count }

    where(:rolls, :expected) do
      [
        [[Roll.new('X')], 1],
        [[Roll.new('3'), Roll.new('4')], 2],
        [[Roll.new('1'), Roll.new('9'), Roll.new('X')], 3]
      ]
    end

    with_them do
      it { is_expected.to eq expected }
    end
  end

  describe '#inspect' do
    subject { Frame.new(rolls).inspect }

    where(:rolls, :expected) do
      [
        [[Roll.new('X')], 'Frame([X])'],
        [[Roll.new('3'), Roll.new('4')], 'Frame([3,4])'],
        [[Roll.new('1'), Roll.new('9'), Roll.new('X')], 'Frame([1,9,X])']
      ]
    end

    with_them do
      it { is_expected.to eq expected }
    end
  end
end
