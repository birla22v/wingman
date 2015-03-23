class ConversationController < ApplicationController

  def create
    @conversation = Conversation.create
    @conversation.users << current_user
  end

  def show
    #paginate
    @conversation = Conversation.find(:id)
    render json: {:messages => @conversation.messages}
  end

  def index
    #get all conversations that include this user
    #order by time stamp updated at
    #return name of all users in the conversation except for current user
    #return conversation
    @user = current_user
    @conversations = @user.conversations.order("updated_at DESC")
    render json: {:conversations => @conversations, :people => @conversations.users}
  end

  def join
    @conversation.users << current_user
  end

end
