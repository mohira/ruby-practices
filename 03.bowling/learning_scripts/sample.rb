#!/usr/bin/env ruby
# frozen_string_literal: true

NUMBER_OF_FRAMES = 10
PIN_OF_FRAME = 10

def build_frames(shot_log)
  (0...NUMBER_OF_FRAMES).map { |frame_index| build_frame(shot_log, frame_index) }
end

def build_frame(shot_log, frame_index)
  is_final_frame = frame_index == (NUMBER_OF_FRAMES - 1)
  is_strike_frame = shot_log.first == PIN_OF_FRAME

  if is_final_frame
    [shot_log.shift, shot_log.shift, shot_log.shift]
  elsif is_strike_frame
    [shot_log.shift, nil]
  else
    [shot_log.shift, shot_log.shift]
  end
end

def strike?(frame)
  frame.first == 10
end

def spare?(frame)
  return false if strike?(frame)

  shot1, shot2 = *frame # 9で止めてるからすべて普通のフレーム

  (shot1 + shot2.to_i) == 10
end

def next_shot(frames, current_frame_index)
  next_frame = frames[current_frame_index + 1]

  next_frame.first
end

def next_second_shot(frames, current_frame_index)
  # MEMO: framesから情報を取り出そうとすると一番ややこしくなる箇所だと思う
  is_9th_frame = current_frame_index == 8
  next_frame = frames[current_frame_index + 1]
  next_shot_is_strike = next_shot(frames, current_frame_index) == 10

  if is_9th_frame
    next_frame[1]
  elsif next_shot_is_strike
    next_second_frame = frames[current_frame_index + 2]
    next_second_frame.first
  else
    next_frame.last
  end
end

def calculate_plain_score(frames)
  frames.sum { |frame| frame.sum(&:to_i) }
end

def calculate_bonus_score(frames)
  frames.first(9).each_with_index.sum do |frame, index_of_frame|
    frame_bonus(frame, frames, index_of_frame)
  end
end

def frame_bonus(frame, frames, index_of_frame)
  if strike?(frame)
    strike_bonus(frames, index_of_frame)
  elsif spare?(frame)
    spare_bonus(frames, index_of_frame)
  else
    0
  end
end

def strike_bonus(frames, current_frame_index)
  next_shot(frames, current_frame_index) + next_second_shot(frames, current_frame_index)
end

def spare_bonus(frames, current_frame_index)
  next_shot(frames, current_frame_index)
end

def calculate_game_score(frames)
  plain_score = calculate_plain_score(frames)
  bonus_score = calculate_bonus_score(frames)

  total_score = plain_score + bonus_score

  warn "[DEBUG] plain=#{plain_score} bonus=#{bonus_score} total=#{total_score}"

  total_score
end

def main
  shot_log = ARGV[0].split(',').map { |c| c == 'X' ? 10 : c.to_i }

  frames = build_frames(shot_log)

  puts calculate_game_score(frames)
end

main
