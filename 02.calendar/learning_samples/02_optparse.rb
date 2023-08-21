# frozen_string_literal: true

require 'date'
require 'optparse'

def main
  params = {
    month: Date.today.month,
    year: Date.today.year
  }

  parser = OptionParser.new do |opt|
    opt.on('-m MONTH', Integer) { |v| params[:month] = v }
    opt.on('-y YEAR', Integer) { |v| params[:year] = v }
  end

  parser.parse!(ARGV)

  p params
end

main
