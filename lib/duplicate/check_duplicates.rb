require_relative '../client_store/fetch_clients'
module Duplicate
  class CheckDuplicates
    def initialize
      @clients = ClientStore::FetchClients.new.fetch
    end

    def get_duplicates_by(attribute = "email")
      @clients.group_by{ |client| client.send(attribute) }.select { |_, clients| clients.size > 1 }
    end
  end
end