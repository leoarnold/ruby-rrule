# frozen_string_literal: true

require 'active_support/all'

module RRule
  autoload :Parser, 'rrule/parser'
  autoload :Rule, 'rrule/rule'
  autoload :Context, 'rrule/context'
  autoload :Weekday, 'rrule/weekday'

  autoload :Frequency, 'rrule/frequencies/frequency'
  autoload :Daily, 'rrule/frequencies/daily'
  autoload :Weekly, 'rrule/frequencies/weekly'
  autoload :SimpleWeekly, 'rrule/frequencies/simple_weekly'
  autoload :Monthly, 'rrule/frequencies/monthly'
  autoload :Yearly, 'rrule/frequencies/yearly'

  autoload :ByMonth, 'rrule/filters/by_month'
  autoload :ByWeekNumber, 'rrule/filters/by_week_number'
  autoload :ByWeekDay, 'rrule/filters/by_week_day'
  autoload :ByYearDay, 'rrule/filters/by_year_day'
  autoload :ByMonthDay, 'rrule/filters/by_month_day'

  autoload :Generator, 'rrule/generators/generator'
  autoload :AllOccurrences, 'rrule/generators/all_occurrences'
  autoload :BySetPosition, 'rrule/generators/by_set_position'

  KEYWORDS = %w[
    FREQ
    UNTIL
    COUNT
    INTERVAL
    BYSECOND
    BYMINUTE
    BYHOUR
    BYDAY
    BYMONTHDAY
    BYYEARDAY
    BYWEEKNO
    BYMONTH
    BYSETPOS
    WKST
  ].freeze

  FREQUENCIES = %w[
    SECONDLY
    MINUTELY
    HOURLY
    DAILY
    WEEKLY
    MONTHLY
    YEARLY
  ].freeze

  WEEKDAYS = %w[SU MO TU WE TH FR SA].freeze

  def self.parse(rrule, **options)
    Rule.new(rrule, **options)
  end

  def self.valid?(rrule)
    Parser.parse!(rrule)

    true
  rescue InvalidRRule
    false
  end

  class InvalidRRule < StandardError; end
end

autoload(:RruleValidator, 'rrule_validator')
