require 'spec_helper'
require_relative '../../../lib/duplicate/check_duplicates_runner'

RSpec.describe Duplicate::CheckDuplicatesRunner do
  let(:runner) { described_class.new }
  let(:mock_check_duplicates) { instance_double(Duplicate::CheckDuplicates) }

  before do
    allow(Duplicate::CheckDuplicates).to receive(:new).and_return(mock_check_duplicates)
  end 

  describe '#run' do
    context 'when no duplicates are found' do
      it 'displays no duplicates message' do
        allow(mock_check_duplicates).to receive(:get_duplicates_by).with('email').and_return({})
        expect { runner.run }.to output("No duplicates found.\n").to_stdout
      end
    end

    context 'when duplicates are found' do
      let(:duplicates) do 
        { 'email@example.com' => [
          Struct.new(:id, :full_name, :email).new(1, 'John Doe', 'email@example.com'),
          Struct.new(:id, :full_name, :email).new(2, 'Jane Smith', 'email@example.com')
        ] }
      end
      
      it 'displays duplicates' do
        allow(mock_check_duplicates).to receive(:get_duplicates_by).with('email').and_return(duplicates)
        expect { runner.run }.to output("Duplicates for email@example.com:\nID:1, Name: John Doe\nID:2, Name: Jane Smith\n").to_stdout
      end
    end
  end
  
end
