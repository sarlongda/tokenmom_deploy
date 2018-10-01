class OrderBroadcastJob < ApplicationJob
  queue_as :default

  def perform(type,order)
    # Do something later
    ActionCable.server.broadcast 'order_channel', type: type, order: order
    
    # if type == "add"
    #   ActionCable.server.broadcast 'order_channel', type: type,order: order
    # elsif type == "remove"
    #   ActionCable.server.broadcast 'order_channel', type: type,order: order
    # elsif type == "update"
    #   ActionCable.server.broadcast 'order_channel', type: type, order: order
    # end  
   
  end
end
