# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/string_helper'

class StringHelperTest < Minitest::Test
  def test_split_three_parts_odd
    assert_equal ['', 'A', ''], split_three_parts('A')
    assert_equal %w[A B C], split_three_parts('ABC')
    assert_equal %w[AB C DE], split_three_parts('ABCDE')
  end

  def test_split_three_parts_even
    assert_equal ['', nil, nil], split_three_parts('')
    assert_equal %w[AB C D], split_three_parts('ABCD')
    assert_equal %w[ABC D EF], split_three_parts('ABCDEF')
  end
end
