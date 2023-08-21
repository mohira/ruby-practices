# frozen_string_literal: true

class InvalidArgumentError < StandardError; end

class OptionsValidator
  def initialize(params)
    @params = params
  end

  def validate
    validate_month
    validate_year
    validate_range_of_month
    validate_after_month
    validate_before_month
  end

  private

  def validate_month
    month = @params[:month]

    return if (1..12).cover?(month)

    raise InvalidArgumentError, "#{month} is not in range (1..12)"
  end

  def validate_year
    year = @params[:year]
    return if (1970..2100).cover?(year)

    raise InvalidArgumentError, "#{year} is not in range (1970..2100)"
  end

  def validate_range_of_month
    return unless @params[:Three]

    raise InvalidArgumentError, '-3 together with -A is not supported' unless @params[:A].nil?
    raise InvalidArgumentError, '-3 together with -B is not supported' unless @params[:B].nil?
  end

  def validate_before_month
    return if @params[:B].nil? || @params[:B].positive?

    raise InvalidArgumentError, 'Argument to -B must be positive'
  end

  def validate_after_month
    return if @params[:A].nil? || @params[:A].positive?

    raise InvalidArgumentError, 'Argument to -A must be positive'
  end
end
