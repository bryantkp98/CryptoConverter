require "uri"
require "net/http"
require "json"
require "./coin"


class Manager
    @@repo ={}
    def initialize
        initialize_repo
    end

    def initialize_repo
        response = scrapeURL
        json = JSON.parse(response)
        # keys = json.keys
        # keys.each do |key|
        #     puts key
        # end

        for symbol, value in json
            coin = Coin.new(symbol, value['USD'],value['EUR'])
            @@repo[symbol] = coin
        end

    end

    def scrapeURL
        url = "https://min-api.cryptocompare.com/data/pricemulti?fsyms=BTC,ETH,XRP,BNB&tsyms=USD,EUR"
        uri = URI(url)
        Net:: HTTP.get(uri)
    end

    def coin_list
        @@repo.keys
    end

    def calcAmount(amount, symbol, to)
        coin = @@repo[symbol]
        amount*coin.send(to.to_sym)
    end
end