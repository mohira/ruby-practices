# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
require_relative 'wc'

class WcStatsTest < Minitest::Test
  def test_count_ascii_text
    text = <<~ASCII
      a
      bb
      ccc
      dddd
    ASCII
    assert_stats(text, 4, 4, 14)
  end

  def test_count_ascii_json
    text = <<~ASCII_JSON
      {
        "name": "John Doe",
        "age": 30,
        "city": "New York",
        "hobbies": [
          "reading",
          "swimming",
          "coding"
        ],
        "details": {
          "height": 180,
          "weight": 75
        },
        "quote": "Hello, World! Welcome to JSON."
      }
    ASCII_JSON

    assert_stats(text, 29, 15, 225)
  end

  def test_count_jp_json
    text = <<~JP_JSON
      {
        "名前": "山田太郎",
        "年齢": 35,
        "住所": "東京都渋谷区",
        "趣味": [
          "読書",
          "旅行",
          "料理"
        ],
        "詳細": {
          "身長": 170,
          "体重": 65
        },
        "メッセージ": "こんにちは、世界！ JSONへようこそ。"
      }
    JP_JSON

    assert_stats(text, 24, 15, 271)
  end

  def test_count_multi_byte_characters
    text = <<~MULTI_BYTES_STRING
      こんにちは、世界！
      Hello,　World!
      タブ文字→	←タブ文字
      改行↓

      ↑改行
      マルチバイト文字：あいうえお
      絵文字：😊🌟🎉
    MULTI_BYTES_STRING

    assert_stats(text, 8, 8, 165)
  end

  def test_count_empty_text
    text = ''

    assert_stats(text, 0, 0, 0)
  end

  def test_only_line_breaks
    text = <<~EMPTY_LINES




    EMPTY_LINES
    assert_stats(text, 0, 4, 4)
  end

  private

  def assert_stats(text, expected_words, expected_lines, expected_bytes)
    actual_words = count_words(text)
    actual_lines = count_lines(text)
    actual_bytes = count_bytes(text)

    errors = []
    errors << "Expected #{expected_words} words, got #{actual_words}" if expected_words != actual_words
    errors << "Expected #{expected_lines} lines, got #{actual_lines}" if expected_lines != actual_lines
    errors << "Expected #{expected_bytes} bytes, got #{actual_bytes}" if expected_bytes != actual_bytes

    assert errors.empty?, errors.join("\n")
  end
end

class WcCommandTest < Minitest::Test
  def test_command_from_standard_input
    in_stream = StringIO.new("a\nbb\nccc\ndddd\n")
    out_stream = StringIO.new
    err_stream = StringIO.new

    argv = []

    expected_output = '       4       4      14'

    exit_code = wc(in_stream, out_stream, err_stream, argv)
    assert_equal 0, exit_code
    assert_equal '', err_stream.string
    assert_equal expected_output, out_stream.string.rstrip
  end

  def test_command_from_files
    in_stream = StringIO.new
    out_stream = StringIO.new
    err_stream = StringIO.new

    argv = %w[dummy_data/a.txt dummy_data/c_jp.json]

    expected_output = <<-EXPECTED
       4       4      14 dummy_data/a.txt
      15      24     271 dummy_data/c_jp.json
      19      28     285 total
    EXPECTED

    exit_code = wc(in_stream, out_stream, err_stream, argv)
    assert_equal 0, exit_code
    assert_equal '', err_stream.string
    assert_equal expected_output, out_stream.string
  end

  def test_command_with_not_exist_file_path
    in_stream = StringIO.new
    out_stream = StringIO.new
    err_stream = StringIO.new

    argv = %w[-lc dummy_data/b_ascii.json not_exist_file]

    expected_output = <<-EXPECTED
      15     225 dummy_data/b_ascii.json
      15     225 total
    EXPECTED

    exit_code = wc(in_stream, out_stream, err_stream, argv)
    assert_equal 1, exit_code
    assert_equal "wc: not_exist_file: No such file or directory\n", err_stream.string
    assert_equal expected_output, out_stream.string
  end
end
