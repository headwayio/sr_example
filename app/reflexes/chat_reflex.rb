class ChatReflex < StimulusReflex::Reflex
  delegate :current_user, to: :connection

  def create_message
    # Create the message
    Message.create(message: params["message"], user_id: current_user.id)

    # Broadcast that everyone on this channel should get messages
    ActionCable.server.broadcast(
      "chat_public_room",
      body: 'get_messages'
    )
  end

   def update_messages; end
end
