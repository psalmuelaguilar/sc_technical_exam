require_relative '../client_store/fetch_clients'
module Search
  class SearchUser
    def initialize
      @clients = ClientStore::FetchClients.new.fetch
    end

    def search(query)
      perform_search(query)
    end

    private

    def perform_search(query)
      q = query.downcase
      @clients.select do |client|
        normalized = client.full_name.downcase
        normalized.include?(q)
      end
    end
  end
end