require 'spec_helper'

RSpec.describe 'Lakebtc integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:btc_usd_pair) { Cryptoexchange::Models::MarketPair.new(base: 'btc', target: 'usd', market: 'lakebtc') }

  it 'fetch pairs' do
    pairs = client.pairs('lakebtc')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'lakebtc'
  end

  it 'give trade url' do
    trade_page_url = client.trade_page_url 'lakebtc', base: btc_usd_pair.base, target: btc_usd_pair.target
    expect(trade_page_url).to eq "https://www.lakebtc.com/deposits/new?currency=usd"
  end

  it 'fetch ticker' do
    ticker = client.ticker(btc_usd_pair)

    expect(ticker.base).to eq 'BTC'
    expect(ticker.target).to eq 'USD'
    expect(ticker.market).to eq 'lakebtc'
    expect(ticker.last).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.bid).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.timestamp).to be nil

    expect(ticker.payload).to_not be nil
  end
end
