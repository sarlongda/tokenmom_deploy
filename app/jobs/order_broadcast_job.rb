class OrderBroadcastJob < ApplicationJob
  queue_as :default

  def perform(type,order = "")
    # Do something later
    
    if type == "add"
      ActionCable.server.broadcast 'order_channel', order: order, type: type
    elsif type == "remove"
      ActionCable.server.broadcast 'order_channel', type: type,order: order
    elsif type == "update"
      ActionCable.server.broadcast 'order_channel', type: type, order: order
    end  
   
  end
end
