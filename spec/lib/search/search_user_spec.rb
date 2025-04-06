require 'spec_helper'
require_relative '../../../lib/search/search_user'

RSpec.describe Search::SearchUser do
  let(:search_user) { described_class.new }
  let(:client_data) do
    [
      Struct.new(:id, :full_name, :email).new(1, 'John Doe', 'john@example.com'),
      Struct.new(:id, :full_name, :email).new(2, 'Jane Smith', 'jane@test.com'),
      Struct.new(:id, :full_name, :email).new(3, 'Bob Johnson', 'bob@example.org')
    ]
  end

  before do
    allow_any_instance_of(ClientStore::FetchClients).to receive(:fetch).and_return(client_data)
  end

  describe '#initialize' do
    it 'loads clients from ClientStore' do
      expect(search_user.instance_variable_get(:@clients)).to eq(client_data)
    end
  end

  describe '#search' do
    context 'with matching query' do
      it 'finds matches in full_name' do
        expect(search_user.search('john').size).to eq(2)
      end

      it 'is case insensitive' do
        expect(search_user.search('JANE').size).to eq(1)
      end

      it 'finds partial matches' do
        expect(search_user.search('smi').size).to eq(1)
      end
    end

    context 'with non-matching query' do
      it 'returns empty array' do
        expect(search_user.search('xyz')).to be_empty
      end
    end

    context 'with empty query' do
      it 'returns all clients' do
        expect(search_user.search('').size).to eq(3)
      end
    end
  end
end 