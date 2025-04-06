require_relative 'search_user'

module Search
  class SearchRunner
    def initialize(args)
      @query = args.join(' ')
    end

    def run(search_by = "full_name")
      if @query.empty?
        puts "Please provide a search string."
        return
      end

      store = SearchUser.new
      results = store.search(@query, search_by)
      if results.nil? || results.empty?
        puts "No results found for \"#{@query}\""
      else
        results.each do |result|
          puts "ID: #{result.id}, Name: #{result.full_name}, Email: #{result.email}"
        end
      end
    end
  end
end