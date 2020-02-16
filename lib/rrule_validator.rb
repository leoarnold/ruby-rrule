# frozen_string_literal: true

class RruleValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    _result, errors = RRule::Parser.parse(value)

    errors.each { |error| record.errors.add(attribute, error.type, message: error.summary) }
  end
end
