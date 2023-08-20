# frozen_string_literal: true

require 'date'
require 'optparse'

class Options
  USAGE = <<-USAGE
  Displays a calendar like the `cal` command.

  Examples
    ./cal.rb                         Display the current month's calendar
    ./cal.rb -m 8                    Display the calendar for current year
    ./cal.rb -m 8 -y 2024            Display the calendar for August 2024

  Options:
  USAGE

  def initialize
    @params = {
      month: Date.today.month,
      year: Date.today.year,
      h: false,
      j: false,
      N: false,
      Three: false
    }

    @parser = define_parser
  end

  def parse(argv)
    @parser.parse!(argv)

    OptionsValidator.new(@params).validate

    @params
  end

  def help
    @parser.help
  end

  private

  def define_parser
    OptionParser.new do |parser|
      parser.banner = USAGE

      parser.on('-m MONTH', '--month MONTH', Integer, 'Display the specified month') { |v| @params[:month] = v }
      parser.on('-y YEAR', '--year YEAR', Integer, 'Display the specified year') { |v| @params[:year] = v }

      parser.on('-h', 'Turns off highlighting of today') { |v| @params[:h] = v }
      parser.on('-j', 'Display Julian days (days one-based, numbered from January 1)') { |v| @params[:j] = v }
      parser.on('-N', 'Display ncal mode') { |v| @params[:N] = v }

      parser.on('-A MONTH', Integer, 'Display the number of months after the current month') { |v| @params[:A] = v }
      parser.on('-B MONTH', Integer, 'Display the number of months before the current month') { |v| @params[:B] = v }
      parser.on('-3', 'Display the previous, current and next month surrounding today') { |v| @params[:Three] = v }
    end
  end
end
