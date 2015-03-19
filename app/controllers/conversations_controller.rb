class ConversationsController < ApplicationController
  before_filter :authenticate_user!

  def create
    if Conversation.between(params[:sender_id],params[:recipient_id]).present?
      @conversation = Conversation.between(params[:sender_id],params[:recipient_id]).first
    else
      @conversation = Conversation.create!(conversation_params)
    end

    render json: { conversation_id: @conversation.id }
  end

  def show
    @conversation = Conversation.find(params[:conversation_id])
    sender_id = @conversation.sender_id
    recipient_id = @conversation.recipient_id
    @conversations= Conversation.where("(sender_id = ? AND recipient_id = ?) OR (sender_id = ? AND recipient_id = ?) ",
    sender_id,recipient_id, recipient_id,sender_id)
    @messages = []
    @conversations.count.times do |i|
     count = @conversations[i].messages.count
       count.times do |j|
          @messages << @conversations[i].messages[j]
       end
    end
    #TODO: sort messages by created_at, render messages...maybe last 10
  end


  def index
    @conversations= Conversation.where("sender_id = ? OR recipient_id = ?", @user.id,@user.id)
    #TODO: in order of last updated
    render json: { conversations: @conversations}
  end

  private
  def conversation_params
    params.permit(:sender_id, :recipient_id)
  end

end
