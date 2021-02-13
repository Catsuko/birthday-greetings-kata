require 'spec_helper'

RSpec.describe Policies::LeapYearInclusiveEvent do
  let(:leap_year_last_feb_day) { DateTime.parse('29th February 2000') }
  let(:non_leap_year_last_feb_day) { DateTime.parse('28th February 1999') }
  let(:key) { :cool_day }
  subject do
    person.fill_out do |_p, details|
      described_class.new(Proc.new { current_date }, key: key).evaluate?(details)
    end
  end

  context 'when the event date is the 29th of Feb' do
    let(:person) { People::FromHash.new(key => leap_year_last_feb_day) }
    
    context 'and the current date is 28th of Feb on a non leap year' do
      let(:current_date) { non_leap_year_last_feb_day }

      it { is_expected.to be_truthy }
    end

    context 'and the current date is the 29th of Feb' do
      let(:current_date) { DateTime.parse('29th February 2004') }

      it { is_expected.to be_truthy }
    end

    context 'and the current date is 28th of Feb on a leap year' do
      let(:current_date) { DateTime.parse('28th February 2000') }

      it { is_expected.to be_falsey }
    end

    context 'and the current date is the 1st of March on a leap year' do
      let(:current_date) { DateTime.parse('1st March 2000') }

      it { is_expected.to be_falsey }
    end
  end

  context 'when the event date is the 28th of Feb' do
    let(:person) { People::FromHash.new(key => non_leap_year_last_feb_day) }

    context 'and the current date is the 29th of Feb' do
      let(:current_date) { leap_year_last_feb_day }

      it { is_expected.to be_falsey }
    end

    context 'and the current date is 28th of Feb on a leap year' do
      let(:current_date) { DateTime.parse('28th February 2000') }

      it { is_expected.to be_truthy }
    end

    context 'and the current date is the 28th of Feb on a non leap year' do
      let(:current_date) { DateTime.parse('28th February 2001') }

      it { is_expected.to be_truthy }
    end
  end
end
