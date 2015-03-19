class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user_id = current_user.id
    @message.save!

    @path = conversation_path(@conversation)
  end

  def index
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
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
