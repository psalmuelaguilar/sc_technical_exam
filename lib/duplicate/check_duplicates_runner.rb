require_relative 'check_duplicates'
module Duplicate
  class CheckDuplicatesRunner
    def initialize
      @check_duplicates = CheckDuplicates.new
    end

    def run
      if @check_duplicates.get_duplicates_by("email").empty?
        puts "No duplicates found."
        return
      end

      @check_duplicates.get_duplicates_by("email").each do |email, clients|
        puts "Duplicates for #{email}:"
        clients.each do |client|
          puts "ID:#{client.id}, Name: #{client.full_name}"
        end
      end
    end
  end
end