# frozen_string_literal: true

require 'rspec-parameterized'
require_relative '../lib/roll'

RSpec.describe Roll do
  describe '#knocked_down_pins' do
    subject { Roll.new(mark).knocked_down_pins }

    context 'given X mark' do
      let(:mark) { 'X' }

      it 'knocked down 10 pins' do
        is_expected.to eq 10
      end
    end

    context 'given numeric mark' do
      where(:mark, :expected) do
        [
          ['0', 0],
          ['1', 1],
          ['2', 2],
          ['3', 3],
          ['4', 4],
          ['5', 5],
          ['6', 6],
          ['7', 7],
          ['8', 8],
          ['9', 9],
          ['10', 10]
        ]
      end

      with_them do
        it "knocked down #{params[:expected]} pins" do
          is_expected.to eq expected
        end
      end
    end
  end

  describe '#==' do
    subject { object1 == object2 }

    context 'when marks are equal' do
      where(:object1, :object2) do
        [
          [Roll.new('X'), Roll.new('X')],
          [Roll.new('1'), Roll.new('1')]
        ]
      end

      with_them do
        it { is_expected.to be true }
      end
    end

    context 'when marks are not equal' do
      where(:object1, :object2) do
        [
          [Roll.new('X'), Roll.new('10')],
          [Roll.new('1'), Roll.new('0')]
        ]
      end

      with_them do
        it { is_expected.to be false }
      end
    end

    context 'when comparing with different class' do
      where(:object1, :object2) do
        [
          [Roll.new('X'), 'X'],
          [Roll.new('X'), 10],
          [Roll.new('1'), '1']
        ]
      end

      with_them do
        it { is_expected.to be false }
      end
    end
  end
end
