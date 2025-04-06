require 'spec_helper'
require_relative '../../../lib/duplicate/check_duplicates'

RSpec.describe Duplicate::CheckDuplicates do
  let(:check_duplicates) { described_class.new }


  before do
    allow_any_instance_of(ClientStore::FetchClients).to receive(:fetch).and_return(client_data)
  end

  describe '#get_duplicates_by' do
    let(:client_data) do
      [
        Struct.new(:id, :full_name, :email).new(1, 'John Doe', 'john@example.com'),
        Struct.new(:id, :full_name, :email).new(2, 'Jane Smith', 'jane@test.com'),
        Struct.new(:id, :full_name, :email).new(3, 'different John Doe', 'john_different@example.com')
      ]
    end

    context 'when no duplicates are found' do
      it 'returns an empty hash' do
        expect(check_duplicates.get_duplicates_by('email')).to eq({})
      end
    end
    
    context 'when duplicates are found' do
      let(:client_data) do
        [
          Struct.new(:id, :full_name, :email).new(1, 'John Doe', 'john@example.com'),
          Struct.new(:id, :full_name, :email).new(2, 'Jane Smith', 'jane@test.com'),
          Struct.new(:id, :full_name, :email).new(3, 'Another John Doe', 'john@example.com')
        ]
      end

      it 'returns a hash with the duplicates' do
        duplicates = check_duplicates.get_duplicates_by('email')
        expect(duplicates.keys).to eq(['john@example.com'])
        expect(duplicates['john@example.com'].map(&:id)).to eq([1, 3])
      end
    end
  end
end