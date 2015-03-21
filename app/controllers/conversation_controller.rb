class ConversationController < ApplicationController

  def create
    @conversation = Conversation.create
    @conversation.users << current_user
  end

  def join
  end

end
