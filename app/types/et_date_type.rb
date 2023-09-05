# frozen_string_literal: true

# This type is used for 2 reasons
# 1. To allow defaulting for things like dates with no day (for refunds)
# 2. To fix a bug in rails where a user entering invalid values (e.g 32 in the day field) would
#     raise an ActiveRecord::MultiparameterAssignmentErrors.  We now ignore this (as if it was nil) so
#     the user gets an error on the form instead.
class EtDateType < ActiveRecord::Type::Date
  # @param [Boolean] omit_day If true, allows a date without a day - will default to the first of the month
  def initialize(omit_day: false, allow_2_digit_year: false)
    @omit_day = omit_day
    @allow_2_digit_year = allow_2_digit_year
    super()
  end

  private

  attr_reader :omit_day, :allow_2_digit_year

  def new_date(year, mon, mday = nil)
    mday ||= 1 if omit_day
    if allow_2_digit_year && year.present? && year.strip.length <= 2
      year = (1900 + year.to_i).to_s
    end
    Date.strptime("#{year}-#{mon}-#{mday}", '%Y-%m-%d')
  rescue ::Date::Error, TypeError
    InvalidDate.new(year, mon, mday)
  end

  def value_from_multiparameter_assignment(value)
    return unless value[1] && value[2] && (value[3] || omit_day)

    values = value.sort.map!(&:last)
    new_date(*values)
  end

  def correct_year(year)
    if year&.to_i&.< 100
      year.to_i + 1900
    end
  end

  def fallback_string_to_date(string)
    new_date(*::Date._parse(string, false).values_at(:year, :mon, :mday).map(&:to_s))
  end

  class InvalidDate
    def initialize(year, month, day)
      @year = year
      @month = month
      @day = day
    end

    attr_reader :day, :month, :year
  end
end
