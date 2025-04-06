#!/usr/bin/env ruby
require_relative '../lib/search/search_runner'
require_relative '../lib/duplicate/check_duplicates_runner'
def clear_screen
  system("clear") || system("cls")
end

def print_welcome_message
  puts "Type 'help' to see available commands."
  puts "Type 'exit' to quit."
  puts "Type 'duplicates' to find duplicate clients."
  puts "Type 'search <query>' to search for a client."
  puts "Type 'clear' to clear the screen."
end

clear_screen
puts "ShiftCare CLI started."
print_welcome_message
loop do
  print "shiftcare> "
  input = gets.chomp.strip
  break if input.downcase == "exit"

  # Split input into arguments array (like ARGV)
  args = input.split

  # Handle special commands
  case args.first&.downcase
  when 'help'
    print_welcome_message
    next
  when 'clear'
    clear_screen
    print_welcome_message
    next
  when 'duplicates'
    Duplicate::CheckDuplicatesRunner.new.run
    next
  when 'search'
    if args.size < 2
      puts "Please provide a search query. Usage: search <query>"
      next
    end
    Search::SearchRunner.new(args[1..-1]).run
    next
  end
end 
