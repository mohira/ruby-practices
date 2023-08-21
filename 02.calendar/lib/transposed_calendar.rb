# frozen_string_literal: true

class TransposedCalendar
  WEEKDAYS = %w[Mo Tu We Th Fr Sa Su].freeze
  attr_reader :year, :month

  def initialize(year, month)
    @year = year
    @month = month
    @start_wday = 1 # TransposedCalendarの場合は月曜(wday=1)はじまり

    @first_date = Date.new(@year, @month, 1)
    @last_date = Date.new(@year, @month, -1)
  end

  def month_name
    @first_date.strftime('%B')
  end

  def date_board
    # Dateオブジェクトの1次元配列を作成し、7つずつ(=曜日の数)に分解して2次元配列にする。
    # 途中で転置するのではなく最後に転置する

    # 盤面サイズは月に関係なく 7 x 6週 で固定。当月に存在しない日付はnilと考える。
    max_n_weeks = 6
    n_of_weekdays = 7
    board_size = n_of_weekdays * max_n_weeks

    # 当月に存在しない日付はnilと考える
    leading_empty_days = [nil] * start_day_index
    trailing_empty_days = [nil] * (board_size - days_in_month.size - start_day_index)

    flattened_dates = leading_empty_days + days_in_month + trailing_empty_days

    flattened_dates.each_slice(n_of_weekdays).to_a.transpose
  end

  def to_s
    whitespace = ' '
    year_month_header = "#{month_name} #{@year}"

    # 各曜日に対して `We Na  4 11 18 25 Na` のような文字列を生成する
    dates = date_board.map.with_index do |row, index|
      str_of_same_weekday = row.map { |date| date.nil? ? 'Na' : date.strftime('%e') }.join(whitespace)
      "#{WEEKDAYS[index]} #{str_of_same_weekday}"
    end.join("\n")

    "#{year_month_header}\n#{dates}\n"
  end

  private

  def days_in_month
    (@first_date..@last_date).to_a
  end

  def start_day_index
    (@first_date.wday - @start_wday) % 7
  end
end
