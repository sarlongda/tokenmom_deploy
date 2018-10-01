class OrderChannel < ApplicationCable::Channel
  def subscribed
    stream_from "order_channel"
  end

  def unsubscribed
  end

  
end