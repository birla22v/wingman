 class UsersController < ApplicationController
   before_action :authenticate_user_from_token!

   def show
     @user = current_user
     render json: { :user => @user }, status: :created
   end

   def create
     @user = User.create(user_params)
   end

  private
   def as_json(opts={})
     super(:only => [:id, :email])
   end

   def user_params
    params.require(:user).permit(:avatar, :gender, :username, :latitude, :longitude, :interests)
   end
 end
