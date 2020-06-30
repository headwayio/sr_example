class ChatController < ApplicationController
  skip_authorization_check

  def index
    render locals: { messages: Message.all.order(created_at: :desc), users: User.all }
  end
end
