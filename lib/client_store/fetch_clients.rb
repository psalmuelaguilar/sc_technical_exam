require 'json'
require 'open-uri'
require 'fileutils'
require 'digest'

module ClientStore
  class FetchClients
    DATA_URL = 'https://appassets02.shiftcare.com/manual/clients.json'

    def fetch
      puts "Fetching client dataset..."
      raw = URI.open(DATA_URL).read
      data = JSON.parse(raw)
      data.map { |c| Struct.new(:id, :full_name, :email).new(c['id'], c['full_name'], c['email']) }
    end
  end
end