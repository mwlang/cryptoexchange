require 'spec_helper'

RSpec.describe 'BinanceDex integration specs' do
  let(:client) { Cryptoexchange::Client.new }
  let(:glc_0c7_bnb_pair) { Cryptoexchange::Models::MarketPair.new(base: 'MITH-C76', target: 'BNB', market: 'binance_dex') }

  it 'fetch pairs' do
    pairs = client.pairs('binance_dex')
    expect(pairs).not_to be_empty

    pair = pairs.first
    expect(pair.base).to_not be nil
    expect(pair.target).to_not be nil
    expect(pair.market).to eq 'binance_dex'
  end

  it 'give trade url' do
    trade_page_url = client.trade_page_url 'binance_dex', base: glc_0c7_bnb_pair.base, target: glc_0c7_bnb_pair.target
    expect(trade_page_url).to eq "https://www.binance.org/en/trade/MITH-C76_BNB"
  end

  it 'fetch ticker' do
    ticker = client.ticker(glc_0c7_bnb_pair)

    expect(ticker.base).to eq 'MITH-C76'
    expect(ticker.target).to eq 'BNB'
    expect(ticker.market).to eq 'binance_dex'
    expect(ticker.last).to be_a Numeric
    expect(ticker.ask).to be_a Numeric
    expect(ticker.bid).to be_a Numeric
    expect(ticker.low).to be_a Numeric
    expect(ticker.high).to be_a Numeric
    expect(ticker.volume).to be_a Numeric
    expect(ticker.change).to be_a Numeric
    expect(ticker.timestamp).to be nil
    expect(ticker.payload).to_not be nil
  end

  it 'fetch order book' do
    order_book = client.order_book(glc_0c7_bnb_pair)

    expect(order_book.base).to eq 'MITH-C76'
    expect(order_book.target).to eq 'BNB'
    expect(order_book.market).to eq 'binance_dex'

    expect(order_book.asks).to_not be_empty
    expect(order_book.bids).to_not be_empty
    expect(order_book.asks.first.price).to_not be_nil
    expect(order_book.bids.first.amount).to_not be_nil
    expect(order_book.bids.first.timestamp).to be_nil
    expect(order_book.asks.count).to be > 10
    expect(order_book.bids.count).to be > 10
    expect(order_book.timestamp).to be_nil
    expect(order_book.payload).to_not be nil
  end

  it 'fetch trades' do
    trades = client.trades(glc_0c7_bnb_pair)
    trade = trades.first

    expect(trade.base).to eq 'MITH-C76'
    expect(trade.target).to eq 'BNB'
    expect(trade.market).to eq 'binance_dex'

    expect(trade.amount).to_not be_nil
    expect(trade.price).to_not be_nil
    expect(2000..Date.today.year).to include(Time.at(trade.timestamp).year)
    expect(trade.trade_id).to_not be_nil
    #expect(trade.type).to eq("buy").or eq("sell")
  end  
end
