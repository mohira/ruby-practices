# frozen_string_literal: true

require 'date'
require 'optparse'

class CLI
  def initialize(out_stream, err_stream)
    @out_stream = out_stream
    @err_stream = err_stream

    @params = {
      month: Date.today.month,
      year: Date.today.year,
      h: false,
      j: false,
      N: false
    }
  end

  def run(argv_org)
    parser.parse!(argv_org.dup)

    if validate?
      @out_stream.puts "#{argv_org} -> #{@params}"
    else
      @out_stream.puts "#{argv_org} -> VALIDATION ERROR"
    end
  end

  private

  def parser
    OptionParser.new do |opt|
      opt.on('-m MONTH', Integer) { |v| @params[:month] = v }
      opt.on('-y YEAR', Integer) { |v| @params[:year] = v }
      opt.on('-h') { |v| @params[:h] = v }
      opt.on('-j') { |v| @params[:j] = v }
      opt.on('-N') { |v| @params[:N] = v }
    end
  end

  def validate?
    year = @params[:year]
    month = @params[:month]

    unless (1970..2100).cover?(year)
      @err_stream.puts "Invalid year #{year}: year must be in (1970..2100)"
      return false
    end

    unless (1..12).cover?(month)
      @err_stream.puts "Invalid month #{month}: month must be in (1..12)"
      return false
    end

    true
  end
end

def main
  argvs = [
    # valid argv
    [],
    %w[-m 8],
    %w[-m 8 -y 1970],
    %w[-m 8 -y 2100 -h],
    %w[-m 8 -y 2100 -h -j -N],
    # Invalid argv
    %w[-m 0],
    %w[-m 13],
    %w[-y 1969],
    %w[-y 2101]
  ]

  cli = CLI.new($stdout, $stderr)

  argvs.each do |argv|
    cli.run(argv)
  end
end

main
