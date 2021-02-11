require 'spec_helper'
require 'csv'

RSpec.describe People::FromCSV do
  describe 'filling out details' do
    let(:delivery_spy) { Delivery::Spy.new }
    let(:csv_path) { 'spec\support\data\birthdays.csv' }
    subject { described_class.new(csv_path) }

    it 'block is invoked once per row' do
      row_count = File.open(csv_path) { |f| f.readlines.size - 1 }
      expect { |b| subject.fill_out(&b) }.to yield_control.exactly(row_count).times
    end

    it 'all columns are provided' do
      expected_keys = CSV.open(csv_path, &:readline).map(&:to_sym)
      subject.fill_out do |_person, details|
        expect(details.keys).to include(*expected_keys)
      end
    end

    it 'each row provides details' do
      expected = CSV.read(csv_path, headers: true).map do |row| 
        [anything, hash_including(first_name: row['first_name'], last_name: row['last_name'])]
      end
      expect { |b| subject.fill_out(&b) }.to yield_successive_args(*expected)
    end

    it 'birthdays are parsed as a date' do
      expected = CSV.read(csv_path, headers: true).map do |row|
        [anything, hash_including(date_of_birth: Date.parse(row['date_of_birth']))]
      end
      expect { |b| subject.fill_out(&b) }.to yield_successive_args(*expected)
    end
  end
end
