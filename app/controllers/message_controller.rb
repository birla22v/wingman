class MessageController < ApplicationController

  def create
    @user = User.find(params[:user_id])
    @conversation = Conversation.find(params[:conversation_id])
    @message = @user.conversations.find(@conversation).messages.create(:body => message_params[:body], :user_id => @user.id)
    #zero push things
  end

  def index
    @message = User.find(:id)
    render json: {:message => @message}
  end

  private
  def message_paramns
    params.require(:message).permit(:body)
  end

end
