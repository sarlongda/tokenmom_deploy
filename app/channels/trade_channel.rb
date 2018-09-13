class TradeChannel < ApplicationCable::Channel
  def subscribed
    stream_from "trade_channel"
  end

  def unsubscribed
  end

  def create_trade(data) 
    
  end
end