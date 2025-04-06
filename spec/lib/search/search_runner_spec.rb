require 'spec_helper'
require_relative '../../../lib/search/search_runner'

RSpec.describe Search::SearchRunner do
  let(:mock_search) { instance_double(Search::SearchUser) }
  let(:sample_results) do
    [
      Struct.new(:id, :full_name, :email).new(1, 'John Doe', 'john@example.com'),
      Struct.new(:id, :full_name, :email).new(2, 'Bob Johnson', 'bob@example.org')
    ]
  end

  before do 
    allow(Search::SearchUser).to receive(:new).and_return(mock_search)
  end

  describe '#run' do
    context 'when empty search query' do
      it 'shows validation message' do
        runner = described_class.new([])
        expect { runner.run }.to output("Please provide a search string.\n").to_stdout
      end
    end

    context 'when query is not empty' do
      it 'displays formatted results' do
        runner = described_class.new(['john'])
        allow(mock_search).to receive(:search).with('john', 'full_name').and_return(sample_results)

        expect { runner.run('full_name') }.to output(
          "ID: 1, Name: John Doe, Email: john@example.com\nID: 2, Name: Bob Johnson, Email: bob@example.org\n"
        ).to_stdout
      end
    end

    context 'when no results are found' do
      it 'shows no results message' do
        runner = described_class.new(['nonexistent'])
        allow(mock_search).to receive(:search).with('nonexistent', 'full_name').and_return([])
        expect { runner.run('full_name') }.to output("No results found for \"nonexistent\"\n").to_stdout
      end
    end

    context 'when search by email' do
      it 'displays formatted results' do
        runner = described_class.new(['john@example.com'])
        allow(mock_search).to receive(:search).with('john@example.com', 'email').and_return(sample_results)
        expect { runner.run('email') }.to output(
          "ID: 1, Name: John Doe, Email: john@example.com\nID: 2, Name: Bob Johnson, Email: bob@example.org\n"
        ).to_stdout
      end
    end
  end
end