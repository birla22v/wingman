 class UsersController < ApplicationController
   before_action :authenticate_user_from_token!

   def show
     @user = current_user
     render json: { :user => @user }, status: :created
   end

   def create
     @user = User.create(user_params)
   end

   def update
     @user = User.find(params[:id])
     @user.update_attribute(:gender, user_params[gender])
     interests = user_params[interests]
     interests.count.times do |i|
       @interest = Interest.find_by(name:interests[i])
       if @interest
         @interest.users << @user
       else
         @user.interests.create(name: interests[i])
       end
     end
   end

  private
   def as_json(opts={})
     super(:only => [:id, :email])
   end

   def user_params
    params.require(:user).permit(:avatar, :gender, :username, :latitude, :longitude, :interests)
   end
 end
