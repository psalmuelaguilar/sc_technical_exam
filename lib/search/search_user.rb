require_relative '../client_store/fetch_clients'
module Search
  class SearchUser
    def initialize
      @clients = ClientStore::FetchClients.new.fetch
    end

    def search(query, search_by = "full_name")
      perform_search(query, search_by)
    end

    private

    def perform_search(query, search_by = "full_name")
      q = query.downcase
      @clients.select do |client|
        if search_by == "id"
          client.id == q.to_i
        else
          begin
            normalized = client.send(search_by).downcase
            normalized.include?(q)
          rescue ArgumentError
            puts "Invalid search by: #{search_by}"
            break
          end
        end
      end
    end
  end
end