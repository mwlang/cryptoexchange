require 'spec_helper'

RSpec.describe 'CoinExchange integration specs' do
  let(:market) { 'coin_exchange' }
  let(:client) { Cryptoexchange::Client.new }
  let(:ltc_btc_pair) { Cryptoexchange::Models::MarketPair.new(base: 'BTBC', target: 'BTC', market: market) }

  it 'fetch pairs' do
    pairs = client.pairs(market)
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).not_to be_nil
    expect(pair.target).not_to be_nil
    expect(pair.market).to eq 'coin_exchange'
  end

  it 'give trade url' do
    trade_page_url = client.trade_page_url market, base: ltc_btc_pair.base, target: ltc_btc_pair.target
    expect(trade_page_url).to eq "https://www.coinexchange.io/market/#{ltc_btc_pair.base}/#{ltc_btc_pair.target}"
  end

  it 'fetch ticker' do
    ticker = client.ticker(ltc_btc_pair)

    expect(ticker.base).to eq 'BTBC'
    expect(ticker.target).to eq 'BTC'
    expect(ticker.market).to eq 'coin_exchange'
    expect(ticker.last).to be_a Numeric
    expect(ticker.bid).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be nil

    expect(ticker.payload).to_not be nil
  end
end
