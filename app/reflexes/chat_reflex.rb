class ChatReflex < StimulusReflex::Reflex
  delegate :current_user, to: :connection

  def create_message
    # Create the message
    Message.create(message: params["message"], user_id: current_user.id)

    # update messages on session
    session[:messages] = Message.all.includes(:user)

    # Broadcast that everyone on this channel should get messages
    ActionCable.server.broadcast(
      "chat_public_room",
      body: 'get_messages'
    )
  end

   def update_messages
     session[:messages] = Message.all.includes(:user)
   end
end
