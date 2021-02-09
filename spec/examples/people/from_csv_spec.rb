require 'spec_helper'
require 'csv'

RSpec.describe People::FromCSV do
  describe 'receiving letters' do
    let(:csv_path) { 'spec\support\data\birthdays.csv' }
    let(:delivery_spy) { Delivery::Spy.new }
    let(:letter) { Letters::Template.new('Hello CSV People!') }
    subject { letter.send_to(described_class.new(csv_path), via: delivery_spy) }

    context 'when csv is fully formed' do
      let(:row_count) { File.open(csv_path) { |f| f.readlines.size - 1 } }

      it 'a letter is delivered to each person listed in the csv' do
        expect { subject }.to change { delivery_spy.delivered_message?(/./) }.by(row_count)
      end
    end

    context 'when letter is personalised' do
      let(:attribute) { 'first_name' }
      let(:letter) { Letters::Template.new("Hello {#{attribute}}") }
      let(:names) { CSV.read(csv_path, headers: true).map { |row| row[attribute] } }

      it 'letters are filled out with details from the csv' do
        subject
        names.each do |name|
          expect(delivery_spy.delivered_message?(/#{name}/)).to be_positive
        end
      end
    end
  end
end
