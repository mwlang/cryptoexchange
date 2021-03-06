require 'spec_helper'

RSpec.describe 'Tdax integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:btc_thb_pair) { Cryptoexchange::Models::MarketPair.new(base: 'BTC', target: 'THB', market: 'tdax') }

  it 'fetch pairs' do
    pairs = client.pairs('tdax')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'tdax'
  end

  it 'give trade url' do
    trade_page_url = client.trade_page_url 'tdax', base: btc_thb_pair.base, target: btc_thb_pair.target
    expect(trade_page_url).to eq "https://satang.pro/exchange/market/BTC-THB"
  end

  it 'fetch ticker' do
    ticker = client.ticker(btc_thb_pair)

    expect(ticker.base).to eq 'BTC'
    expect(ticker.target).to eq 'THB'
    expect(ticker.market).to eq 'tdax'
    expect(ticker.last).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.bid).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.change).to be_a Numeric
    expect(ticker.timestamp).to be nil
    
    expect(ticker.payload).to_not be nil
  end
end
