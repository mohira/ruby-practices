# frozen_string_literal: true

def split_three_parts(str)
  # 文字列を3つのパートに分解する
  middle_index = str.length / 2

  left_part = str[0...middle_index]
  middle_part = str[middle_index]
  right_part = str[(middle_index + 1)..]

  [left_part, middle_part, right_part]
end

def substitute_string(original_string, substring, start_index)
  s = original_string.dup

  s[start_index, substring.length] = substring

  s
end
