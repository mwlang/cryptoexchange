module Cryptoexchange::Exchanges
  module Coinxpro
    module Services
      class Market < Cryptoexchange::Services::Market
        class << self
          def supports_individual_ticker_query?
            false
          end
        end

        def fetch
          output = super(ticker_url)
          adapt_all(output)
        end

        def ticker_url
          "#{Cryptoexchange::Exchanges::Coinxpro::Market::API_URL}"
        end

        def adapt_all(output)
          output["data"].map do |pair|
            base, target = pair["contract"].split('/')
            market_pair = Cryptoexchange::Models::MarketPair.new(
              base: base,
              target: target,
              market: Coinxpro::Market::NAME
            )
            adapt(pair, market_pair)
          end
        end

        def adapt(output, market_pair)
          ticker           = Cryptoexchange::Models::Ticker.new
          ticker.base      = market_pair.base
          ticker.target    = market_pair.target
          ticker.market    = Coinxpro::Market::NAME
          ticker.last      = NumericHelper.to_d(output['last'])
          ticker.bid       = NumericHelper.to_d(output['bid'])
          ticker.ask       = NumericHelper.to_d(output['ask'])
          ticker.volume    = NumericHelper.divide(NumericHelper.to_d(output['volume']), ticker.last)
          ticker.timestamp = nil
          ticker.payload   = output
          ticker
        end
      end
    end
  end
end