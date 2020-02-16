# frozen_string_literal: true

require 'active_model'
require 'spec_helper'

describe RruleValidator do
  subject(:model) { model_class.new(rrule) }

  let(:rrule) { self.class.description }

  let(:model_class) do
    Class.new do
      def self.name
        'ModelClass'
      end

      include ActiveModel::Validations

      attr_reader :recurrence_rule

      def initialize(recurrence_rule)
        @recurrence_rule = recurrence_rule
      end

      validates :recurrence_rule, rrule: true
    end
  end

  let(:errors) { model.errors }

  before do
    model.valid?
  end

  describe 'nil' do
    let(:rrule) { nil }

    it { is_expected.to be_invalid }
  end

  describe 'an empty String' do
    let(:rrule) { '' }

    it { is_expected.to be_invalid }
  end

  describe 'COUNT=1' do
    it { is_expected.to be_invalid }
  end

  describe 'FREQ=' do
    it { is_expected.to be_invalid }
  end

  describe 'FREQ=DAILY' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;BYMONTH=1,3;COUNT=4' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;BYMONTH=1,3;COUNT=4;BYDAY=TU,TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;BYMONTH=1,3;COUNT=4;BYDAY=TU,TH;BYMONTHDAY=1,3' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;BYMONTH=1,3;COUNT=4;BYMONTHDAY=5,7' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;COUNT=-1' do
    it { is_expected.to be_invalid }
  end

  describe 'FREQ=DAILY;COUNT=10' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;COUNT=1.5' do
    it { is_expected.to be_invalid }
  end

  describe 'FREQ=DAILY;COUNT=3' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;COUNT=3;BYDAY=TU,TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;COUNT=3;INTERVAL=2' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;COUNT=3;INTERVAL=92' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;COUNT=4;BYDAY=TU,TH;BYMONTHDAY=1,3' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;COUNT=4;BYMONTHDAY=1,3' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;COUNT=7' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;COUNT=BOOM' do
    it { is_expected.to be_invalid }
  end

  describe 'FREQ=DAILY;INTERVAL=0' do
    it { is_expected.to be_invalid }
  end

  describe 'FREQ=DAILY;INTERVAL=-1' do
    it { is_expected.to be_invalid }
  end

  describe 'FREQ=DAILY;INTERVAL=10' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;INTERVAL=10;COUNT=5' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;INTERVAL=1.1' do
    it { is_expected.to be_invalid }
  end

  describe 'FREQ=DAILY;INTERVAL=2' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;INTERVAL=BOOM' do
    it { is_expected.to be_invalid }
  end

  describe 'FREQ=DAILY;UNTIL=19970901T170000Z' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;UNTIL=19970902T160000Z' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;UNTIL=19970904T160000Z' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;UNTIL=19970905T150000Z' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;UNTIL=19971224T000000Z' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=DAILY;UNTIL=20000131T140000Z;BYMONTH=1' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=FOO' do
    it { is_expected.to be_invalid }
  end

  describe 'FREQ=FOO;COUNT=1' do
    it { is_expected.to be_invalid }
  end

  describe 'FREQ=MONTHLY;BYDAY=FR;BYMONTHDAY=13;COUNT=6' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;BYDAY=SA;BYMONTHDAY=7,8,9,10,11,12,13' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;BYMONTH=1,3;COUNT=4' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;BYMONTH=1,3;COUNT=4;BYDAY=1TU,-1TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;BYMONTH=1,3;COUNT=4;BYDAY=3TU,-3TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;BYMONTH=1,3;COUNT=4;BYDAY=TU,TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;BYMONTH=1,3;COUNT=4;BYDAY=TU,TH;BYMONTHDAY=1,3' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;BYMONTH=1,3;COUNT=4;BYMONTHDAY=5,7' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;BYMONTHDAY=15,30;COUNT=5' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;BYMONTHDAY=-3' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;COUNT=10;BYDAY=1FR' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;COUNT=10;BYMONTHDAY=1,-1' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;COUNT=10;BYMONTHDAY=2,15' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;COUNT=3' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;COUNT=3;BYDAY=1TU,-1TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;COUNT=3;BYDAY=TU,TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;COUNT=3;INTERVAL=18' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;COUNT=3;INTERVAL=2' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;COUNT=4;BYDAY=3TU,-3TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;COUNT=4;BYDAY=TU,TH;BYMONTHDAY=1,3' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;COUNT=4;BYMONTHDAY=1,3' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;COUNT=6;BYDAY=-2MO' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;INTERVAL=18;COUNT=10;BYMONTHDAY=10,11,12,13,14,15' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;INTERVAL=2;BYDAY=TU' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;INTERVAL=2;COUNT=10;BYDAY=1SU,-1SU' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;UNTIL=19971224;BYDAY=1FR' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=MONTHLY;UNTIL=19971224T000000Z;BYDAY=1FR' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;BYDAY=20MO' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;BYDAY=TH;BYMONTH=6,7,8' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;BYMONTH=1,3;COUNT=4' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;BYMONTH=1,3;COUNT=4;BYDAY=1TU,-1TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;BYMONTH=1,3;COUNT=4;BYDAY=3TU,-3TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;BYMONTH=1,3;COUNT=4;BYDAY=TU,TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;BYMONTH=1,3;COUNT=4;BYDAY=TU,TH;BYMONTHDAY=1,3' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;BYMONTH=1,3;COUNT=4;BYMONTHDAY=5,7' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;BYMONTH=2;COUNT=1;BYMONTHDAY=31' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;BYMONTH=3;BYDAY=TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;COUNT=10;BYMONTH=6,7' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;COUNT=3' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;COUNT=3;BYDAY=TU,TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;COUNT=3;INTERVAL=100' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;COUNT=3;INTERVAL=2' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;COUNT=4;BYDAY=1TU,-1TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;COUNT=4;BYDAY=3TU,-3TH' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;COUNT=4;BYDAY=TU,TH;BYMONTHDAY=1,3' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;COUNT=4;BYMONTHDAY=1,3' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;COUNT=5;BYYEARDAY=1,100,200,365' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;COUNT=5;BYYEARDAY=-365,-266,-166,-1' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;INTERVAL=1;BYDAY=MO,-1TU;UNTIL=20160901T200000Z' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;INTERVAL=2;COUNT=10;BYMONTH=1,2,3' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;INTERVAL=3;COUNT=10;BYYEARDAY=1,100,200' do
    it { is_expected.to be_valid }
  end

  describe 'FREQ=YEARLY;INTERVAL=4;BYMONTH=11;BYDAY=TU;BYMONTHDAY=2,3,4,5,6,7,8' do
    it { is_expected.to be_valid }
  end
end
