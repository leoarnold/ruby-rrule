# frozen_string_literal: true

module RRule
  class SyntaxError
    attr_reader :rrule, :type, :summary, :markers

    def initialize(rrule:, type:, summary:, markers:)
      @rrule = rrule
      @type = type
      @markers = Array.wrap(markers)
      @summary = positions.blank? ? summary : "#{summary} at #{positions}"
    end

    def message
      <<~MESSAGE.rstrip
        * #{@summary}:

        \t'#{@rrule}'
        \t #{markings}
      MESSAGE
    end

    private

    def markings
      return if @markers.blank?

      (0..rrule.length).map do |i|
        @markers.any? { |range| range.include?(i) } ? '^' : ' '
      end.join
    end

    def positions
      return if @markers.blank?

      positions = @markers.map(&:first)

      if positions.count == 1
        "position #{positions.first}"
      else
        "positions #{positions.take(positions.length - 1).join(', ')} and #{positions.last}"
      end
    end
  end

  # A pragmatic parser for RFC5545 +RRULE+ (+RECUR+ value) expressions
  # handwritten (for better readability and maintainability)
  # in plain Ruby (therefore platform independent)
  #
  # @author Leo Arnold
  # @see https://tools.ietf.org/html/rfc5545#section-3.3.10 RFC5545 iCalendar, section 3.3.10. Recurrence Rule
  class Parser
    class << self
      def parse!(expression)
        result, errors = parse(expression)

        raise InvalidRRule, "SyntaxError\n\n#{errors.map(&:message).join("\n")}\n" if errors.any?

        result
      end

      def parse(expression)
        new(expression).parse
      end

      def valid?(expression)
        _result, errors = parse(expression)

        errors.none?
      end
    end

    def initialize(expression)
      @scanner = StringScanner.new(expression || '')
    end

    def parse
      @scanner.reset
      @keyword = nil
      @errors = []
      result = {}

      until @scanner.eos?
        @scanner.getch while @scanner.peek(1) == ';'

        keyword_node = expect_keyword

        if keyword_node
          @keyword = keyword_node[:value]
          result[keyword_node] = nil
        else
          skip_rule_part && next
        end

        value_node = expect_value

        if value_node
          result[keyword_node] = value_node
        else
          skip_rule_part && next
        end
      end

      check_mandatory_keywords(result)
      check_duplicate_keywords(result)
      check_mutually_exclusive_keywords(result)

      result = result.select { |_k, v| v.present? }.transform_keys { |k| k[:value] }.transform_values { |v| v[:value] }

      [result, @errors]
    end

    def check_mandatory_keywords(result)
      syntax_error(summary: "missing keyword 'FREQ'", type: :missing_keyword) unless result.keys.any? { |k| k[:value] == 'FREQ' }
    end

    def check_duplicate_keywords(result)
      result.keys.group_by { |keyword_node| keyword_node[:value] }.select { |_keyword, keyword_nodes| keyword_nodes.length > 1 }.each do |keyword, nodes|
        syntax_error(summary: "keyword '#{keyword}' appeared more than once", type: :duplicate_keyword, markers: nodes.map { |node| (node[:position]..(node[:position] + keyword.length - 1)) })
      end
    end

    def check_mutually_exclusive_keywords(result)
      nodes = result.select { |k, _v| %w[COUNT UNTIL].include?(k[:value]) }

      return if nodes.count < 2

      syntax_error(summary: "keywords 'COUNT' and 'UNTIL' are mutually exclusive", type: :mutually_exclusive_keywords, markers: nodes.keys.map { |node| (node[:position]..(node[:position] + node[:value].length - 1)) })
    end

    def expect_keyword
      position = @scanner.pos
      value = ''

      until @scanner.eos?
        case @scanner.peek(1)
        when /[A-Z]/i
          value += @scanner.getch
        when '='
          @scanner.getch

          break if KEYWORDS.include?(value.upcase)

          if value.empty?
            syntax_error(summary: 'missing keyword', type: :missing_keyword, markers: (@scanner.pos..@scanner.pos))
          else
            syntax_error(summary: "unknown keyword '#{value}'", type: :unknown_keyword, markers: ((@scanner.pos - value.length - 1)..(@scanner.pos - 2)))
          end

          return
        when /[;]/
          break if KEYWORDS.include?(value.upcase)

          if value.empty?
            syntax_error(summary: 'missing keyword', type: :missing_keyword, markers: (@scanner.pos..@scanner.pos))
          else
            syntax_error(summary: "unknown keyword '#{value}'", type: :unknown_keyword, markers: ((@scanner.pos - value.length - 1)..(@scanner.pos - 2)))
          end

          return
        else
          position = @scanner.pos

          syntax_error(summary: "illegal character '#{@scanner.getch}'", type: :illegal_character, markers: (position..position))

          return
        end
      end

      { position: position, value: value.upcase }
    end

    def expect_value
      case @keyword
      when 'FREQ'
        expect_freq
      when 'UNTIL'
        expect_date_or_time
      when 'COUNT', 'INTERVAL'
        node = expect_integer

        return if node.blank?

        value = node[:value]

        return node if value > 0

        syntax_error(summary: "invalid '#{@keyword}' value '#{value}', expected positive integer", type: :bad_value, markers: (node[:position]..(node[:position] + value.to_s.length - 1)))
      when 'BYSECOND', 'BYMINUTE', 'BYHOUR', 'BYWEEKNO', 'BYMONTH', 'BYMONTHDAY', 'BYYEARDAY', 'BYSETPOS'
        expect_integer_list
      when 'WKST'
        expect_weekday
      when 'BYDAY'
        expect_weekday_list
      else
        syntax_error(summary: "unknown keyword '#{@keyword}'", type: :unknown_keyword, markers: ((@scanner.pos - value.length - 1)..(@scanner.pos - 2)))
      end
    end

    def expect_date_or_time
      position = @scanner.pos
      value = @scanner.scan(/[^;]+/)

      case value
      when /^\d{8}$/
        { position: position, value: Date.strptime(value, '%Y%m%d') }
      when /^\d{8}T\d{6}Z$/
        { position: position, value: Time.strptime(value, '%Y%m%dT%H%M%S%Z') }
      else
        syntax_error(summary: "invalid 'UNTIL' value '#{value}', expected date or date-time", type: :bad_value, markers: (position..(@scanner.pos - 1))) && return
      end
    end

    def expect_integer_list
      position = @scanner.pos
      list = []

      until @scanner.eos?
        case @scanner.peek(1)
        when /[+\-\d]/
          value = @scanner.scan(/[^,;]+/)

          list.push(value.to_i) && next if value =~ /^[+-]?\d+$/

          syntax_error(summary: "invalid value '#{value}', expected integer", type: :bad_value, markers: (position..(@scanner.pos - 1)))
        when /,/
          @scanner.getch
        when /;/
          @scanner.getch

          break
        else
          syntax_error(summary: 'Illegal character', type: :illegal_character, markers: (@scanner.pos..@scanner.pos))

          return
        end
      end

      { position: position, value: list }
    end

    def expect_weekday
      position = @scanner.pos
      value = @scanner.scan(/[^;$]+/) || ''

      return { position: position, value: value.upcase } if value.upcase =~ /^([+-]?[1-9]\d*)?(#{WEEKDAYS.join('|')})$/

      syntax_error(summary: "invalid '#{@keyword}' value '#{value}'", type: :bad_value, markers: (position..(position + [0, value.length - 1].max)))
    end

    def expect_weekday_list
      position = @scanner.pos
      list = []

      until @scanner.eos?
        case @scanner.peek(1)
        when /[+\-\w]/
          value = @scanner.scan(/[^,;]+/)

          list.push(value) && next if value =~ /^([+-]?[1-9]\d*)?(#{WEEKDAYS.join('|')})$/

          syntax_error(summary: "invalid value '#{value}', expected integer", type: :bad_value, markers: (position..(@scanner.pos - 1)))
        when /,/
          @scanner.getch
        when /;/
          @scanner.getch

          break
        else
          syntax_error(summary: 'Illegal character', type: :illegal_character, markers: (@scanner.pos..@scanner.pos))

          return
        end
      end

      { position: position, value: list }
    end

    def expect_integer
      position = @scanner.pos
      value = @scanner.scan(/[^;$]+/) || ''

      return { position: position, value: value.to_i } if value =~ /^[+\-]?\d+$/

      syntax_error(summary: "invalid '#{@keyword}' value '#{value}'", type: :bad_value, markers: (position..(position + [0, value.length - 1].max)))
    end

    def expect_freq
      position = @scanner.pos
      value = @scanner.scan(/[^;$]+/) || ''

      return { position: position, value: value.upcase } if FREQUENCIES.include?(value.upcase)

      if value.empty?
        syntax_error(summary: "missing '#{@keyword}' value", type: :missing_value, markers: (position..position))
      else
        syntax_error(summary: "invalid '#{@keyword}' value '#{value}'", type: :bad_value, markers: (position..(position + [0, value.length - 1].max)))
      end
    end

    def skip_rule_part
      @keyword = nil
      @scanner.scan_until(/;|$/)
    end

    def syntax_error(summary:, type:, markers: [])
      @errors << SyntaxError.new(
        rrule: @scanner.string,
        summary: summary,
        type: type,
        markers: markers
      )

      nil
    end
  end
end
