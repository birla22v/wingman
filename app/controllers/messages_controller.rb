class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user_id = current_user.id
    @message.save!
    notification = {
      device_tokens: [params[:device_token_one], params[:device_token_two]],
      alert: @message,
      sound: "default",
      badge: 1
    }

    ZeroPush.notify(notification)
  end

  

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
