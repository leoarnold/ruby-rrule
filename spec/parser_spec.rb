# frozen_string_literal: true

require 'spec_helper'

describe RRule::Parser do
  describe '.parse!' do
    subject { described_class.parse!(rrule) }

    let(:rrule) { self.class.description }

    describe 'FREQ=DAILY' do
      it { is_expected.to eq('FREQ' => 'DAILY') }
    end

    describe 'FREQ=DAILY;BYMONTH=1,3;COUNT=4' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'BYMONTH' => [1, 3], 'COUNT' => 4) }
    end

    describe 'FREQ=DAILY;BYMONTH=1,3;COUNT=4;BYDAY=TU,TH' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'BYMONTH' => [1, 3], 'COUNT' => 4, 'BYDAY' => %w[TU TH]) }
    end

    describe 'FREQ=DAILY;BYMONTH=1,3;COUNT=4;BYDAY=TU,TH;BYMONTHDAY=1,3' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'BYMONTH' => [1, 3], 'COUNT' => 4, 'BYDAY' => %w[TU TH], 'BYMONTHDAY' => [1, 3]) }
    end

    describe 'FREQ=DAILY;BYMONTH=1,3;COUNT=4;BYMONTHDAY=5,7' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'BYMONTH' => [1, 3], 'COUNT' => 4, 'BYMONTHDAY' => [5, 7]) }
    end

    describe 'FREQ=DAILY;COUNT=10' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'COUNT' => 10) }
    end

    describe 'FREQ=DAILY;COUNT=3' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'COUNT' => 3) }
    end

    describe 'FREQ=DAILY;COUNT=3;BYDAY=TU,TH' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'COUNT' => 3, 'BYDAY' => %w[TU TH]) }
    end

    describe 'FREQ=DAILY;COUNT=3;INTERVAL=2' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'COUNT' => 3, 'INTERVAL' => 2) }
    end

    describe 'FREQ=DAILY;COUNT=3;INTERVAL=92' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'COUNT' => 3, 'INTERVAL' => 92) }
    end

    describe 'FREQ=DAILY;COUNT=4;BYDAY=TU,TH;BYMONTHDAY=1,3' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'COUNT' => 4, 'BYDAY' => %w[TU TH], 'BYMONTHDAY' => [1, 3]) }
    end

    describe 'FREQ=DAILY;COUNT=4;BYMONTHDAY=1,3' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'COUNT' => 4, 'BYMONTHDAY' => [1, 3]) }
    end

    describe 'FREQ=DAILY;COUNT=7' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'COUNT' => 7) }
    end

    describe 'FREQ=DAILY;INTERVAL=10' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'INTERVAL' => 10) }
    end

    describe 'FREQ=DAILY;INTERVAL=10;COUNT=5' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'INTERVAL' => 10, 'COUNT' => 5) }
    end

    describe 'FREQ=DAILY;INTERVAL=2' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'INTERVAL' => 2) }
    end

    describe 'FREQ=DAILY;UNTIL=19970901T170000Z' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'UNTIL' => Time.parse('Sep  1 17:00:00 UTC 1997')) }
    end

    describe 'FREQ=DAILY;UNTIL=19970902T160000Z' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'UNTIL' => Time.parse('Sep  2 16:00:00 UTC 1997')) }
    end

    describe 'FREQ=DAILY;UNTIL=19970904T160000Z' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'UNTIL' => Time.parse('Sep  4 16:00:00 UTC 1997')) }
    end

    describe 'FREQ=DAILY;UNTIL=19970905T150000Z' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'UNTIL' => Time.parse('Sep  5 15:00:00 UTC 1997')) }
    end

    describe 'FREQ=DAILY;UNTIL=19971224T000000Z' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'UNTIL' => Time.parse('Dec 24 00:00:00 UTC 1997')) }
    end

    describe 'FREQ=DAILY;UNTIL=20000131T140000Z;BYMONTH=1' do
      it { is_expected.to eq('FREQ' => 'DAILY', 'UNTIL' => Time.parse('Jan 31 14:00:00 UTC 2000'), 'BYMONTH' => [1]) }
    end

    describe 'FREQ=MONTHLY;BYDAY=FR;BYMONTHDAY=13;COUNT=6' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'BYDAY' => ['FR'], 'BYMONTHDAY' => [13], 'COUNT' => 6) }
    end

    describe 'FREQ=MONTHLY;BYDAY=SA;BYMONTHDAY=7,8,9,10,11,12,13' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'BYDAY' => ['SA'], 'BYMONTHDAY' => [7, 8, 9, 10, 11, 12, 13]) }
    end

    describe 'FREQ=MONTHLY;BYMONTH=1,3;COUNT=4' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'BYMONTH' => [1, 3], 'COUNT' => 4) }
    end

    describe 'FREQ=MONTHLY;BYMONTH=1,3;COUNT=4;BYDAY=1TU,-1TH' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'BYMONTH' => [1, 3], 'COUNT' => 4, 'BYDAY' => ['1TU', '-1TH']) }
    end

    describe 'FREQ=MONTHLY;BYMONTH=1,3;COUNT=4;BYDAY=3TU,-3TH' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'BYMONTH' => [1, 3], 'COUNT' => 4, 'BYDAY' => ['3TU', '-3TH']) }
    end

    describe 'FREQ=MONTHLY;BYMONTH=1,3;COUNT=4;BYDAY=TU,TH' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'BYMONTH' => [1, 3], 'COUNT' => 4, 'BYDAY' => %w[TU TH]) }
    end

    describe 'FREQ=MONTHLY;BYMONTH=1,3;COUNT=4;BYDAY=TU,TH;BYMONTHDAY=1,3' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'BYMONTH' => [1, 3], 'COUNT' => 4, 'BYDAY' => %w[TU TH], 'BYMONTHDAY' => [1, 3]) }
    end

    describe 'FREQ=MONTHLY;BYMONTH=1,3;COUNT=4;BYMONTHDAY=5,7' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'BYMONTH' => [1, 3], 'COUNT' => 4, 'BYMONTHDAY' => [5, 7]) }
    end

    describe 'FREQ=MONTHLY;BYMONTHDAY=15,30;COUNT=5' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'BYMONTHDAY' => [15, 30], 'COUNT' => 5) }
    end

    describe 'FREQ=MONTHLY;BYMONTHDAY=-3' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'BYMONTHDAY' => [-3]) }
    end

    describe 'FREQ=MONTHLY;COUNT=10;BYDAY=1FR' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'COUNT' => 10, 'BYDAY' => ['1FR']) }
    end

    describe 'FREQ=MONTHLY;COUNT=10;BYMONTHDAY=1,-1' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'COUNT' => 10, 'BYMONTHDAY' => [1, -1]) }
    end

    describe 'FREQ=MONTHLY;COUNT=10;BYMONTHDAY=2,15' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'COUNT' => 10, 'BYMONTHDAY' => [2, 15]) }
    end

    describe 'FREQ=MONTHLY;COUNT=3' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'COUNT' => 3) }
    end

    describe 'FREQ=MONTHLY;COUNT=3;BYDAY=1TU,-1TH' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'COUNT' => 3, 'BYDAY' => ['1TU', '-1TH']) }
    end

    describe 'FREQ=MONTHLY;COUNT=3;BYDAY=TU,TH' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'COUNT' => 3, 'BYDAY' => %w[TU TH]) }
    end

    describe 'FREQ=MONTHLY;COUNT=3;INTERVAL=18' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'COUNT' => 3, 'INTERVAL' => 18) }
    end

    describe 'FREQ=MONTHLY;COUNT=3;INTERVAL=2' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'COUNT' => 3, 'INTERVAL' => 2) }
    end

    describe 'FREQ=MONTHLY;COUNT=4;BYDAY=3TU,-3TH' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'COUNT' => 4, 'BYDAY' => ['3TU', '-3TH']) }
    end

    describe 'FREQ=MONTHLY;COUNT=4;BYDAY=TU,TH;BYMONTHDAY=1,3' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'COUNT' => 4, 'BYDAY' => %w[TU TH], 'BYMONTHDAY' => [1, 3]) }
    end

    describe 'FREQ=MONTHLY;COUNT=4;BYMONTHDAY=1,3' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'COUNT' => 4, 'BYMONTHDAY' => [1, 3]) }
    end

    describe 'FREQ=MONTHLY;COUNT=6;BYDAY=-2MO' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'COUNT' => 6, 'BYDAY' => ['-2MO']) }
    end

    describe 'FREQ=MONTHLY;INTERVAL=18;COUNT=10;BYMONTHDAY=10,11,12,13,14,15' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'INTERVAL' => 18, 'COUNT' => 10, 'BYMONTHDAY' => [10, 11, 12, 13, 14, 15]) }
    end

    describe 'FREQ=MONTHLY;INTERVAL=2;BYDAY=TU' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'INTERVAL' => 2, 'BYDAY' => ['TU']) }
    end

    describe 'FREQ=MONTHLY;INTERVAL=2;COUNT=10;BYDAY=1SU,-1SU' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'INTERVAL' => 2, 'COUNT' => 10, 'BYDAY' => ['1SU', '-1SU']) }
    end

    describe 'FREQ=MONTHLY;UNTIL=19971224;BYDAY=1FR' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'UNTIL' => Date.parse('Dec 24 1997'), 'BYDAY' => ['1FR']) }
    end

    describe 'FREQ=MONTHLY;UNTIL=19971224T000000Z;BYDAY=1FR' do
      it { is_expected.to eq('FREQ' => 'MONTHLY', 'UNTIL' => Time.parse('Dec 24 00:00:00 UTC 1997'), 'BYDAY' => ['1FR']) }
    end

    describe 'FREQ=YEARLY;BYDAY=20MO' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'BYDAY' => ['20MO']) }
    end

    describe 'FREQ=YEARLY;BYDAY=TH;BYMONTH=6,7,8' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'BYDAY' => ['TH'], 'BYMONTH' => [6, 7, 8]) }
    end

    describe 'FREQ=YEARLY;BYMONTH=1,3;COUNT=4' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'BYMONTH' => [1, 3], 'COUNT' => 4) }
    end

    describe 'FREQ=YEARLY;BYMONTH=1,3;COUNT=4;BYDAY=1TU,-1TH' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'BYMONTH' => [1, 3], 'COUNT' => 4, 'BYDAY' => ['1TU', '-1TH']) }
    end

    describe 'FREQ=YEARLY;BYMONTH=1,3;COUNT=4;BYDAY=3TU,-3TH' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'BYMONTH' => [1, 3], 'COUNT' => 4, 'BYDAY' => ['3TU', '-3TH']) }
    end

    describe 'FREQ=YEARLY;BYMONTH=1,3;COUNT=4;BYDAY=TU,TH' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'BYMONTH' => [1, 3], 'COUNT' => 4, 'BYDAY' => %w[TU TH]) }
    end

    describe 'FREQ=YEARLY;BYMONTH=1,3;COUNT=4;BYDAY=TU,TH;BYMONTHDAY=1,3' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'BYMONTH' => [1, 3], 'COUNT' => 4, 'BYDAY' => %w[TU TH], 'BYMONTHDAY' => [1, 3]) }
    end

    describe 'FREQ=YEARLY;BYMONTH=1,3;COUNT=4;BYMONTHDAY=5,7' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'BYMONTH' => [1, 3], 'COUNT' => 4, 'BYMONTHDAY' => [5, 7]) }
    end

    describe 'FREQ=YEARLY;BYMONTH=2;COUNT=1;BYMONTHDAY=31' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'BYMONTH' => [2], 'COUNT' => 1, 'BYMONTHDAY' => [31]) }
    end

    describe 'FREQ=YEARLY;BYMONTH=3;BYDAY=TH' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'BYMONTH' => [3], 'BYDAY' => ['TH']) }
    end

    describe 'FREQ=YEARLY;COUNT=10;BYMONTH=6,7' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'COUNT' => 10, 'BYMONTH' => [6, 7]) }
    end

    describe 'FREQ=YEARLY;COUNT=3' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'COUNT' => 3) }
    end

    describe 'FREQ=YEARLY;COUNT=3;BYDAY=TU,TH' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'COUNT' => 3, 'BYDAY' => %w[TU TH]) }
    end

    describe 'FREQ=YEARLY;COUNT=3;INTERVAL=100' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'COUNT' => 3, 'INTERVAL' => 100) }
    end

    describe 'FREQ=YEARLY;COUNT=3;INTERVAL=2' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'COUNT' => 3, 'INTERVAL' => 2) }
    end

    describe 'FREQ=YEARLY;COUNT=4;BYDAY=1TU,-1TH' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'COUNT' => 4, 'BYDAY' => ['1TU', '-1TH']) }
    end

    describe 'FREQ=YEARLY;COUNT=4;BYDAY=3TU,-3TH' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'COUNT' => 4, 'BYDAY' => ['3TU', '-3TH']) }
    end

    describe 'FREQ=YEARLY;COUNT=4;BYDAY=TU,TH;BYMONTHDAY=1,3' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'COUNT' => 4, 'BYDAY' => %w[TU TH], 'BYMONTHDAY' => [1, 3]) }
    end

    describe 'FREQ=YEARLY;COUNT=4;BYMONTHDAY=1,3' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'COUNT' => 4, 'BYMONTHDAY' => [1, 3]) }
    end

    describe 'FREQ=YEARLY;COUNT=5;BYYEARDAY=1,100,200,365' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'COUNT' => 5, 'BYYEARDAY' => [1, 100, 200, 365]) }
    end

    describe 'FREQ=YEARLY;COUNT=5;BYYEARDAY=-365,-266,-166,-1' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'COUNT' => 5, 'BYYEARDAY' => [-365, -266, -166, -1]) }
    end

    describe 'FREQ=YEARLY;INTERVAL=1;BYDAY=MO,-1TU;UNTIL=20160901T200000Z' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'INTERVAL' => 1, 'BYDAY' => ['MO', '-1TU'], 'UNTIL' => Time.parse('Sep  1 20:00:00 UTC 2016')) }
    end

    describe 'FREQ=YEARLY;INTERVAL=2;COUNT=10;BYMONTH=1,2,3' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'INTERVAL' => 2, 'COUNT' => 10, 'BYMONTH' => [1, 2, 3]) }
    end

    describe 'FREQ=YEARLY;INTERVAL=3;COUNT=10;BYYEARDAY=1,100,200' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'INTERVAL' => 3, 'COUNT' => 10, 'BYYEARDAY' => [1, 100, 200]) }
    end

    describe 'FREQ=YEARLY;INTERVAL=4;BYMONTH=11;BYDAY=TU;BYMONTHDAY=2,3,4,5,6,7,8' do
      it { is_expected.to eq('FREQ' => 'YEARLY', 'INTERVAL' => 4, 'BYMONTH' => [11], 'BYDAY' => ['TU'], 'BYMONTHDAY' => [2, 3, 4, 5, 6, 7, 8]) }
    end

    context 'with syntax errors' do
      describe 'nil' do
        let(:rrule) { nil }

        it 'raises an exception' do
          expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
            SyntaxError

            * missing keyword 'FREQ':

            \t''
          MESSAGE
        end
      end

      describe 'an empty String' do
        let(:rrule) { '' }

        it 'raises an exception' do
          expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
            SyntaxError

            * missing keyword 'FREQ':

            \t''
          MESSAGE
        end
      end

      describe 'FRUQ=DAILY;BYDEY=MO;CONTTT=1' do
        it 'raises an exception mentioning the * missing keyword FREQ' do
          message = <<~MESSAGE
            * missing keyword 'FREQ':

            \t'FRUQ=DAILY;BYDEY=MO;CONTTT=1'
          MESSAGE

          expect { subject }.to raise_error(RRule::InvalidRRule).with_message(/#{Regexp.escape(message)}/)
        end

        it 'raises an exception mentioning FRUQ' do
          message = <<~MESSAGE
            unknown keyword 'FRUQ' at position 0:

            \t'FRUQ=DAILY;BYDEY=MO;CONTTT=1'
            \t ^^^^
          MESSAGE

          expect { subject }.to raise_error(RRule::InvalidRRule).with_message(/#{Regexp.escape(message)}/)
        end

        it 'raises an exception mentioning BYDEY' do
          message = <<~MESSAGE
            unknown keyword 'BYDEY' at position 11:

            \t'FRUQ=DAILY;BYDEY=MO;CONTTT=1'
            \t            ^^^^^
          MESSAGE

          expect { subject }.to raise_error(RRule::InvalidRRule).with_message(/#{Regexp.escape(message)}/)
        end

        it 'raises an exception mentioning CONTTT' do
          message = <<~MESSAGE
            unknown keyword 'CONTTT' at position 20:

            \t'FRUQ=DAILY;BYDEY=MO;CONTTT=1'
            \t                     ^^^^^^
          MESSAGE

          expect { subject }.to raise_error(RRule::InvalidRRule).with_message(/#{Regexp.escape(message)}/)
        end
      end

      describe 'FREQ' do
        describe 'FREQ' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * missing 'FREQ' value at position 4:

              \t'FREQ'
              \t     ^
            MESSAGE
          end
        end

        describe 'FREQ,' do
          it 'raises an exception' do
            message = <<~MESSAGE
              SyntaxError

              * illegal character ',' at position 4:

              \t'FREQ,'
              \t     ^
            MESSAGE

            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(/#{Regexp.escape(message)}/)
          end
        end

        describe 'FREQ;' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * missing 'FREQ' value at position 4:

              \t'FREQ;'
              \t     ^
            MESSAGE
          end
        end

        describe 'FREQ=' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * missing 'FREQ' value at position 5:

              \t'FREQ='
              \t      ^
            MESSAGE
          end
        end

        describe 'FREQ=;' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * missing 'FREQ' value at position 5:

              \t'FREQ=;'
              \t      ^
            MESSAGE
          end
        end

        describe 'FREQ=BiMonthly' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * invalid 'FREQ' value 'BiMonthly' at position 5:

              \t'FREQ=BiMonthly'
              \t      ^^^^^^^^^
            MESSAGE
          end
        end

        describe 'FREQ=1' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * invalid 'FREQ' value '1' at position 5:

              \t'FREQ=1'
              \t      ^
            MESSAGE
          end
        end

        describe 'FREQ=SA,SU' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * invalid 'FREQ' value 'SA,SU' at position 5:

              \t'FREQ=SA,SU'
              \t      ^^^^^
            MESSAGE
          end
        end

        describe 'FREQ=YEARLY;FREQ=YEARLY' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * keyword 'FREQ' appeared more than once at positions 0 and 12:

              \t'FREQ=YEARLY;FREQ=YEARLY'
              \t ^^^^        ^^^^
            MESSAGE
          end
        end

        describe 'FREQ=YEARLY;FREQ=MONTHLY;FREQ=DAILY' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * keyword 'FREQ' appeared more than once at positions 0, 12 and 25:

              \t'FREQ=YEARLY;FREQ=MONTHLY;FREQ=DAILY'
              \t ^^^^        ^^^^         ^^^^
            MESSAGE
          end
        end
      end

      describe 'COUNT' do
        describe 'COUNT=1' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * missing keyword 'FREQ':

              \t'COUNT=1'
            MESSAGE
          end
        end

        describe 'FREQ=DAILY;COUNT=-1' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * invalid 'COUNT' value '-1', expected positive integer at position 17:

              \t'FREQ=DAILY;COUNT=-1'
              \t                  ^^
            MESSAGE
          end
        end

        describe 'FREQ=DAILY;COUNT=1.5' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * invalid 'COUNT' value '1.5' at position 17:

              \t'FREQ=DAILY;COUNT=1.5'
              \t                  ^^^
            MESSAGE
          end
        end

        describe 'FREQ=DAILY;COUNT=1,5' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * invalid 'COUNT' value '1,5' at position 17:

              \t'FREQ=DAILY;COUNT=1,5'
              \t                  ^^^
            MESSAGE
          end
        end

        describe 'FREQ=DAILY;COUNT=BOOM' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * invalid 'COUNT' value 'BOOM' at position 17:

              \t'FREQ=DAILY;COUNT=BOOM'
              \t                  ^^^^
            MESSAGE
          end
        end

        describe 'FREQ=DAILY;COUNT=SA,SU' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * invalid 'COUNT' value 'SA,SU' at position 17:

              \t'FREQ=DAILY;COUNT=SA,SU'
              \t                  ^^^^^
            MESSAGE
          end
        end

        describe 'FREQ=DAILY;COUNT=10;UNTIL=19971224T000000Z' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * keywords 'COUNT' and 'UNTIL' are mutually exclusive at positions 11 and 20:

              \t'FREQ=DAILY;COUNT=10;UNTIL=19971224T000000Z'
              \t            ^^^^^    ^^^^^
            MESSAGE
          end
        end
      end

      describe 'UNTIL' do
        describe 'FREQ=DAILY;UNTIL=MO' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * invalid 'UNTIL' value 'MO', expected date or date-time at position 17:

              \t'FREQ=DAILY;UNTIL=MO'
              \t                  ^^
            MESSAGE
          end
        end

        describe 'FREQ=DAILY;UNTIL=202003' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * invalid 'UNTIL' value '202003', expected date or date-time at position 17:

              \t'FREQ=DAILY;UNTIL=202003'
              \t                  ^^^^^^
            MESSAGE
          end
        end
      end

      describe 'INTERVAL' do
        describe 'FREQ=DAILY;INTERVAL=0' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * invalid 'INTERVAL' value '0', expected positive integer at position 20:

              \t'FREQ=DAILY;INTERVAL=0'
              \t                     ^
            MESSAGE
          end
        end

        describe 'FREQ=DAILY;INTERVAL=-1' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * invalid 'INTERVAL' value '-1', expected positive integer at position 20:

              \t'FREQ=DAILY;INTERVAL=-1'
              \t                     ^^
            MESSAGE
          end
        end

        describe 'FREQ=DAILY;INTERVAL=1.1' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * invalid 'INTERVAL' value '1.1' at position 20:

              \t'FREQ=DAILY;INTERVAL=1.1'
              \t                     ^^^
            MESSAGE
          end
        end

        describe 'FREQ=DAILY;INTERVAL=BOOM' do
          it 'raises an exception' do
            expect { subject }.to raise_error(RRule::InvalidRRule).with_message(<<~MESSAGE)
              SyntaxError

              * invalid 'INTERVAL' value 'BOOM' at position 20:

              \t'FREQ=DAILY;INTERVAL=BOOM'
              \t                     ^^^^
            MESSAGE
          end
        end
      end
    end
  end
end
