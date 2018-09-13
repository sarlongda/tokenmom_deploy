class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel"
  end

  def unsubscribed
  end

  def send_message(data)
    Message.create(content: data['message'],room_id: data['room_id'], user_id: data['user_id'])
  end
end